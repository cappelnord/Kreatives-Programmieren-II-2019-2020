s.latency = nil;

(
SynthDef(\pling, {|freq=440, attack=0.001, release=1, out=0, pan=0, amp=0.1|
	var sig = SinOsc.ar(freq);
	var env = EnvGen.ar(Env.perc(attack, release), doneAction: 2);
	Out.ar(out, Pan2.ar(sig * amp * env, pan));
}).add;
)

(
// Versuch das Orca MIDI Interface nachzuahmen
OSCdef(\orca0, {|msg, time, addr, recvPort|
	var octave = msg[1] ? 4;
	var degree = msg[2] ? 9;
	var amp = (msg[3] ? 7).linexp(0, 36, 0.001, 1);
	var dur = (msg[4] ? 5) * 0.125;
	msg.postln;
	(
		instrument: \pling,
		octave: octave,
		scale: Scale.chromatic,
		degree: msg[2],
		amp: amp,
		release: dur
	).play;
}, '/0');
)