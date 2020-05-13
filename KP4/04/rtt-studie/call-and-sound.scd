NetAddr.langPort;

// Achtung: outChannel unten anpassen!

( // config
/*
s.options.inDevice = "MME : In 1-24 (MOTU Pro Audio)";
s.options.outDevice = "MME : Out 1-24 (MOTU Pro Audio)";
s.options.numOutputBusChannels = 4;
*/

s.options.memSize = 32768;
s.reboot;
)

s.meter;


( // live code parameters
var durations = Prand([0.5], inf).asStream * 2;
~nextDuration = {
	durations.next;
};

~numGroups = 4;
~degrees = (0..5);
~octaves = [3, 4, 5, 6];
~scale = Scale.chromatic;

)

( // SynthDefs
SynthDef(\delay, {|in, out=0, time=1|
	var sig = In.ar(in, 2);
	sig = FbC({|fb| (sig + fb) * 0.85}, time, time, 2) + sig * 0.5;
	Out.ar(out, sig);
}).add;

SynthDef(\sound, {|freq=440, out=0, amp=0.1, pan=0, modRatio=1|

	var staticAmp = 1.0;

	// to decorelate
	var lfAmpMod = SinOsc.kr(Rand(0.2, 0.8), phase: Rand(0, 2pi)).range(0.95, 1.0);
	var lfFreqMod = SinOsc.kr(Rand(0.1, 4.0), phase: Rand(0, 2pi)).range(-3, 3);

	var mod = SinOsc.ar(modRatio * freq + lfFreqMod, mul: XLine.ar(freq * 2, 0.01, 0.15));
	var sig = SinOsc.ar(freq + mod) * lfAmpMod;
	var env = EnvGen.ar(Env.perc(0.001, 1), doneAction: 2);
	Out.ar(out, Pan2.ar(sig * env * amp * AmpComp.kr(freq, 110) * staticAmp, pan));
}).add;

SynthDef(\reverb, {|in, out|
	var sig = In.ar(in, 2);
	Out.ar(out, sig + (JPverb.ar(sig, 2) * 0.09));
}).add;
)

( // Main Game
var outChannel = 0;

var net = NetAddr("127.0.0.1", 57150);
var minRTT = 0.04;
var maxRTT = 0.5; // everything that takes longer can be discarded
var numDelays = 16;
var delayDenominator = (4.0 / numDelays);
var baseDelay = 4.0 * delayDenominator;

var callID = 0;
var data = ();

var reverbBus = Bus.audio(s, 2);
var reverb = Synth(\reverb, [\in, reverbBus, \out, outChannel]);

var delayBusses = numDelays.collect {|i|
	var bus = Bus.audio(s, 2);
	Synth(\delay, [\out, reverbBus, \in, bus, \time, baseDelay + ((i) * delayDenominator)]);
	bus;
};

var play = {|clientID, rtt|
	// first generate some parameters from the clientID ...
	// ... very random, but at least they will stay the same.

	var pan = (clientID % 1000).linlin(0, 1000, -1, 1);
	var amp = 0.1;
	var degree = ~degrees[clientID % ~degrees.size];
	var octave = ~octaves[clientID % ~octaves.size];
	var modRatio = 1 + (clientID % 5);

	// this is derived from the rtt
	var rttIndex = rtt.explin(minRTT, maxRTT, 0, numDelays).floor.asInteger;
	var timingOffset = rttIndex * (0.0 / 64.0); // maybe not needed

	("RTT Index:" + rttIndex).postln;

	(
		\instrument: \sound,
		\out: delayBusses[rttIndex],
		\scale: ~scale,
		\octave: octave,
		\degree: degree,
		\modRatio: modRatio,
		\pan: pan,
		\amp: 0.3,
		\timingOffset: timingOffset
	).play;
};

// returns a funciton which will be scheduled
var playResponses = {|thisCallID|
	{
		var responses = data[thisCallID][\responses];
		("Play:" + thisCallID).postln;
		responses.postln;
		data.removeAt(thisCallID);
		responses.do {|response|
			play.value(response[\id], response[\rtt]);
		};
	};
};

OSCdef(\response, {|msg|
	// [s: cmd, i: clientID, i: callID]
	var callID = msg[2];
	var clientID = msg[1];


	// if this is nil then message was too late, so discard!
	data[callID].isNil.not.if {
		data[callID][\responses].add((
			id: clientID,
			rtt: TempoClock.default.beats - data[callID][\time]
		));
	};
}, '\response');

// main loop
fork {
	inf.do {
		net.sendMsg('/call', callID % ~numGroups, callID, ~numGroups);
		("Call:"+ callID).postln;
		data[callID] = (time: TempoClock.default.beats, responses: List());
		TempoClock.default.sched(maxRTT, playResponses.value(callID));
		callID = callID + 1;
		~nextDuration.value.wait;
	};
};
)
