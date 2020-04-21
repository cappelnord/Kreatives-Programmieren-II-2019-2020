////////////////////////////////////////////////////////////
// patterns mit ndefs
////////////////////////////////////////////////////////////

////////////////////
// 1. dirty 
(
Ndef(\sine, {
	arg freq = 40;
	SinOsc.ar(freq)
}).play;
)

Ndef(\sine).stop;
Ndef(\sine).play;
Ndef(\sine).set(\freq, 70)

(
Pdef(\test, 
	Pbind(
		\amp, 0, // einfach den default synth muten
		\jfjfjfjfjfjjf, Pfunc({Ndef(\sine).set(\freq, rrand(50, 100))})
	)
).play;
)

////////////////////
// 2. stattdessen vielleicht lieber fork?

////////////////////
// 3. oder mit Demand UGens
// kurze wiederholung: Dseq, Drand, Dwhite
(
Ndef(\demand_beispiel, {
	var trig = Impulse.ar(4);
	var freq = Demand.ar(trig, 0, Drand((0..8) * 50, inf));
	var snd = SinOsc.ar(freq);
	snd;
})
)

////////////////////
// 4.1. semi-modular, d.h. einige module, ein synth, der vom pattern gesteuert wird
(
Ndef(\lfo, {
	arg freq = 0.5;
	SinOsc.kr(freq);
});
)

// kurze wiederholung: wir haben auch ausserhalb der klammern zugriff
// auf \lfo, weil ndef (genauso wie ProxySpace) alle Proxys in einem
// dictionary speichert.
Ndef.dictFor(s);

NdefMixer(s);

Ndef(\lfo).bus;

(
SynthDef(\myinstrument, {
	var snd = Saw.ar(100);
	snd = RLPF.ar(snd, In.kr(Ndef(\lfo).bus).range(100, 5000));
	Out.ar(0, snd);
}).add;
)

Synth(\myinstrument);

// 4.2 dasselbe nur etwas eleganter und einfacher (nach ein wenig
// recherche nachtraeglich hinzugefuegt):

(
Ndef(\lfo, {
	SinOsc.ar(10);
})
)

(
SynthDef(\testsnd, {
	arg out = 0;
	var snd = SinOsc.ar(440) * Ndef(\lfo); // man kann direkt "ndef" im synthdef  verwenden
	var env = Env.perc().kr(2);
	snd = snd * env;
	Out.ar(out, snd);
}).add;
)

NdefMixer(s);

// um einen effekt zu verwenden (ohne kopfzerbrechen mit bussen),
// routen wir das audio vom synthdef in ein platzhalter-ndef:
Ndef.ar(\testsndout);

(
Pdef(\test, 
	Pbind(
		\instrument, \testsnd,
		\out, Ndef(\testsndout).bus
)).play;
)

// platzhalter verwenden:
Ndef(\effect, {var in = Ndef(\testsndout); in + DelayC.ar(in, 1, MouseX.kr(0.1, 1))});



////////////////////////////////////////////////////////////
// variablen-scopes

~b = 10; // environment variable
a = 15; // gobal variable

(
a; // global
)

(
var a; // local
a = 200;
a;
)

a; // global




////////////////////////////////////////////////////////////
// fadeTime bei control-Ndefs

Ndef(\freq, 300);

(
Ndef(\snd, {
	arg freq = 100;
	var snd = SinOsc.ar(freq);
	snd;
})
)

Ndef(\snd).map(\freq, Ndef(\freq));

Ndef(\freq).fadeTime = 10;

Ndef(\freq, {SinOsc.kr(0.5).range(300, 500)}); // kr ndefs machen lineare interpolation anstatt crossfade






////////////////////////////////////////////////////////////
// roads beipsiel


// Consider a series of eighth notes, where every other note is
// accented, every third note is repositioned in space, every fourth
// note has vibrato, every fifth note is ring-modulated, and every
// sixth note changes pitch. Here the onset times are regular and the
// durations are all the same. The perceived rhythm is a function of
// patterns in dynamics, space, ornamentation, timbre, and pitch. Thus
// we can speak of the rhythm of a given dynamic, space,
// ornamentation, timbre, or pitch change, which can be a sudden
// discrete transition or a continuous variation over time.
// 
// Roads, Curtis. Composing electronic music: a new aesthetic. Oxford
// University Press, USA, 2015.

(
SynthDef(\sine, {
	arg amp = 1, pan = 0, gate = 1, freq = 440, vib_freq = 8, vibrato = 0, ringmod = 0;
	var snd, env, vib, rmd;
	rmd = if(ringmod, {SinOsc.ar(LFNoise2.kr(5).range(20, 200))}, 1);
	vib = if(vibrato, {SinOsc.ar(vib_freq)}, 1);
	snd = SinOsc.ar(freq + (vib * 0.1)) * rmd;
	env = Env.adsr(0.01, 0.05, 0.8, 0.1).kr(2, gate);
	snd = snd * env * amp * vib.range(0.25, 1);
	snd = Pan2.ar(snd, pan);
	Out.ar(0, snd);
}).add;
)

(
Pdef(\roads, 
	Pbind(
		\instrument, \sine,
		\amp, Pseq([0.3, 0.9], inf),
		\pan, Pseq([-1, -1, 1], inf),
		\legato, 0.7,
		\dur, 1 / 8,
		\vibrato, Pseq([0, 0, 0, 1], inf),
		\vib_freq, 8,
		\ringmod, Pseq([0, 0, 0, 0, 1], inf),
		// \degree, Pseq([0, 0, 0, 0, 0, Prand((0..6), 1)], inf) // jede 6. ist ein anderer pitch
		// jede 6. den pitch ändern:
		\degree, Pstutter(6, Pxrand((0..6), inf))
	)
).play;
)

Pdef(\roads).stop;


////////////////////////////////////////////////////////////
// if mit ugens

{ if( LFNoise1.kr(1.0, 0.5, 0.5) , SinOsc.ar, Saw.ar ) * 0.1 }.play;
{ if( MouseX.kr(0, 1), SinOsc.ar, Saw.ar ) * 0.1 }.play;