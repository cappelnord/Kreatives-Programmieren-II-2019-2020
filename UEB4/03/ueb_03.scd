/* ========================================================

   -----------------------------------------------------
   Übungen zu Kreatives Programmieren 4: SuperCollider 2
   -----------------------------------------------------

   Sitzung 03 - 06.05.2020

======================================================== */



// ------------------------------------------------------
// Recieve osc-messages from Processing for synth control
// ------------------------------------------------------


// Define synth

(
SynthDef(\sound, { | freq = 400, amp = 0.5 |
	var snd = SinOsc.ar(freq);
	Out.ar(0, snd * amp !2)
}).add
)

x = Synth(\sound);
x.free;



// Define OSCdef

(
var freq, amp;

OSCdef(\recieve, { |msg|

	// msg.postln;

	// conversions are nedded since processing's coordinate systems
	// has its origin (0, 0) at the upper left corner

	freq = msg[1] + msg[3]; // scale frequency range -> width to (width*2)
	amp = (msg[3] - msg[2]) / msg[3]; // invert y-axis and scale amplitude range -> 0 to 1

	x.set(\freq, freq, \amp, amp);

}, '/freq_amp') // listen to messages matching the '/freq_amp' path
)
)

