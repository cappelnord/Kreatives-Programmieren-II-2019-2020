// Ndefs


Ndef(\snd);

Ndef(\snd, {SinOsc.ar()});

Ndef(\snd).isPlaying;
Ndef(\snd).bus;


Ndef(\snd2, {Saw.ar()});
Ndef(\snd2).bus;


s.scope;

Ndef(\snd).play;
Ndef(\snd).stop;

Ndef(\snd).monitor.isPlaying;
NdefMixer(s);
Ndef(\snd).vol = 0.4;




// modular
Ndef(\snd, {SinOsc.ar(Ndef(\lfo))});
Ndef(\snd).play;

Ndef(\lfo, {LFSaw.ar(0.5).range(100, 500)});




// neu definieren von ndefs (on the fly)

Ndef(\lfo, {LFSaw.ar(200).range(100, 5000)}); // werte verändern und direkt ausführen

Ndef.dictFor(s); // auch Ndefs haben einen ProxySpace



//////////////////////////////////////////////////////////////////////
// verschiedene schreibweisen

// Ndef-Schreibweise
Ndef(\snd, {SinOsc.ar(Ndef(\lfo))});
Ndef(\snd).play;

Ndef(\lfo, {LFSaw.ar(0.5).range(100, 500)});


// ProxySpace-Schreibweise

currentEnvironment
p = ProxySpace(s);
p.push;

~snd = {SinOsc.ar(~lfo)};
~snd.play;

~lfo = {LFSaw.ar(0.5).range(100, 500)};

~snd.monitor.isPlaying; // genauso wie bei Ndefs möglich

p // schauen, was im proxy-space definiert ist

p.clear;
p.pop;

currentEnvironment
~y = 10
~x = SinOsc

// NodeProxy-Schreibweise
(
var snd, lfo;
snd = NodeProxy(s).play; // snd
lfo = NodeProxy(s); // lfo
snd.source = {SinOsc.ar(l.kr)};
lfo.source = {LFSaw.ar(0.5).range(100, 500)};

snd.monitor.isPlaying;

lfo.fadeTime = 0;
snd.fadeTime = 10;
)





// parameter / argumente

Ndef(\snd, {arg freq = 440; SinOsc.ar(freq)});
Ndef(\snd).play;
Ndef(\snd).stop;
Ndef(\snd).gui;
Ndef(\snd).set(\freq, 440); // frequenz mit 'set' setzen
Ndef(\snd).fadeTime = 3;
Ndef(\snd).xset(\freq, 100); // xset für crossfade
Ndef(\snd).xset(\freq, 1000);

Ndef(\snd).map(\freq, Ndef(\lfo)); // frequenz mit lfo kontrollieren
Ndef(\lfo, {LFNoise2.ar(0.5).range(3000, 4000)});
Ndef(\lfo2, {SinOsc.ar(2).range(100, 200)});
Ndef(\snd).map(\freq, Ndef(\lfo2));
Ndef(\snd).xmap(\freq, Ndef(\lfo)); // xmap für crossfade



// back to modular
Ndef(\snd2, {arg freq = 400; Decay.ar(Impulse.ar(1), 0.1) * SinOsc.ar(freq, pi / 2)}).play;

Ndef(\snd2).stop;
Ndef(\del, {var in = Ndef(\snd2); in + (DelayC.ar(in) * 0.5)}).play; // effekt


// feedback
Ndef(\fb, {(PinkNoise.ar(0.01) + (DelayC.ar(Ndef.ar(\fb), 0.1, MouseX.kr(0.1, 0.001)) * MouseY.kr(1.1, 0.6))).tanh}).play;










// Demand

(
Ndef(\snd, {
	var trig, seq;
	trig = Impulse.ar(3);
	seq = Demand.ar(trig, 0, Dseq([60, 67, 69, 59].midicps, inf)); // wie Pseq
	SinOsc.ar(seq);
}).play;
)

Ndef(\snd).fadeTime = 1;

(
Ndef(\snd, {
	var trig, seq;
	trig = Impulse.ar(3);
	seq = Demand.ar(trig, 0, Drand([60, 67, 69, 59].midicps, inf));
	SinOsc.ar(seq);
}).play;
)

(
Ndef(\snd, {
	var trig, seq;
	trig = Impulse.ar(3);
	seq = Demand.ar(trig, 0, Dxrand([60, 67, 69, 59].midicps, inf));
	SinOsc.ar(seq);
}).play;
)

(
Ndef(\snd, {
	var trig, seq;
	trig = Impulse.ar(3);
	seq = Demand.ar(trig, 0, Dwhite(100, 500, inf));
	SinOsc.ar(seq);
}).play;
)

(
Ndef(\snd, {
	var trig, seq;
	trig = Impulse.ar(3);
	seq = Demand.ar(trig, 0, Diwhite(60, 80, inf)).poll.midicps; // wie Dwhite nur mit Integers
	SinOsc.ar(seq);
}).play;
)