/* ========================================================

   -----------------------------------------------------
   Übungen zu Kreatives Programmieren 4: SuperCollider 2
   -----------------------------------------------------

   Sitzung 05 - 20.05.2020

======================================================== */


s.meter;
s.scope;


n = NetAddr("127.0.0.1", 57120);  // set network address (OSCjunction for sending to other user)



// Build a wavetable manually with an array
(
var size = 512;

a = Array.fill(size, { |i|

	sin(i/size * 2 * pi)  // one cycle of a sine wave

	//sin(i/size * 5 * pi) * sin(i/size * 3 * pi);  // modulating sines
});
)


//a = a.normalize(-1, 1);  // normalize to keep signal in range if math goes odd...
a.plot;

b = Buffer.loadCollection(s, a);  // load wavetable to buffer
b.plot;



// Wavetable Synth
(
SynthDef(\waveTable, { | buffer, freq = 400 |
	var snd;
	snd = BufRd.ar(1, buffer, LFSaw.ar(freq).range(0, BufFrames.ir(buffer) - 1));
	Out.ar(0, snd * 0.5)
}).add;
)


x = Synth(\waveTable);
x.free;



// OSCdef to get the wavetable from remote-user
(
OSCdef(\waveTable, { |msg|

	//msg.postln;

	fork{
		b.loadCollection(msg[1..].asArray, 0);  // fill buffer with new values
		s.sync;  // wait for wavetable to be loaded by server
		x.set(\buffer, b)
	};

}, '/waveCycle')
)



// Send Array with wavetable to remote-user
(
{
	| ...args | n.sendMsg("/waveCycle", *args)
}.valueArray(a);
)
