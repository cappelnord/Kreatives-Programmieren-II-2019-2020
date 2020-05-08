// Splay

{Splay.ar(SinOsc.ar([100, 500, 1000]))}.play;

// patricks beispiel:

// hier kann man ganz gut beobachten, wie sich der abstand der einzelnen impulse vergroessert
{Impulse.ar([10, 10.0001, 10.0002, 10.0003]).sum}.scope;
{Splay.ar(Impulse.ar([10, 10.0001, 10.0002, 10.0003]))}.scope;

(
var n = 8;
n.do{
	|i|
	(10 + (i * 0.0001)).postln; // frequenzen
	((i % 2 == 0).if(1, -1)).postln; // mul --> signal bipolar
}
)

(
{
	var n = 200;
	Splay.ar(
		n.collect{ |i|
		Impulse.ar(10 + (0.0001 * i)) * (i % 2 == 0).if(1, -1)
	});
}.scope;
)

// dasselbe mit multichannel expansion:
{Splay.ar(Impulse.ar(10 + Array.series(2000, 0, 0.0001)) * [1, -1])}.play;


// polymetrik
{Splay.ar(Impulse.ar(10 / Array.series(8, 1, 1))) * 0.2}.play;

(
{
	var n = 4;
	var freqs = Array.series(n, 1, 1);
	var trigger = Impulse.ar(10 / freqs);
	var env = Decay.ar(trigger, 0.1);
	var snd = SinOsc.ar(freqs * 200);
	(n - 1).lcm(n).postln;
	Splay.ar(snd * env) * 0.2;
}.play;
)