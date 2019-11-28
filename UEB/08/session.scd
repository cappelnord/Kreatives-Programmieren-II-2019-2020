/////////////////////////////////////////////////////////////
// parameter

(
Ndef(\fb, {
	Decay.ar(Impulse.ar(1)) * Crackle.ar(1.5) +
	(DelayC.ar(Ndef.ar(\fb)) * MouseX.kr(0.7, 1.1)) // feedback
});
)

Ndef(\fb).play;

(
Ndef(\fb, {
	arg fbAmp = 0.7, tFreq = 1;
	Decay.ar(Impulse.ar(tFreq), 0.1) * Crackle.ar(1.5) +
	(DelayC.ar(Ndef(\fb)) * fbAmp) // feedback
});
)

// parameter kontrollieren

// 1. set
Ndef(\fb).set(\fbAmp, 0.9);
Ndef(\fb).set(\fbAmp, 0.9, \tFreq, 1);
Ndef(\fb).set(\tFreq, 2);
Ndef(\fb).set(\fbAmp, 1.0, \tFreq, 3);
Ndef(\fb).set(\fbAmp, 1.1);

// 2. NdefMixer
n = NdefMixer(s); n.parent.alwaysOnTop = true;
// uebrigens: so kann man auch das scope-fenster auf "alwaysOnTop" setzen
o = s.scope.window; o.alwaysOnTop = true;

Ndef.clear; n.close; // alle Ndefs clearen und den NdefMixer schliessen

// 3. NdefGui
p = Ndef(\fb).gui; p.parent.alwaysOnTop = true; // alternativ: alt-Click auf "ed" im NdefMixer

Ndef(\sine, {arg freq = 440; SinOsc.ar(freq)});
q = Ndef(\sine).gui; q.parent.alwaysOnTop = true;

/////////////////////////////////////////////////////////////
// control rate / buffer time

Ndef(\fb, {PinkNoise.ar(0.01) + LeakDC.ar(Ndef.ar(\fb) * MouseX.kr(0.6, 1.1))});
Ndef(\fb).clear;

// welche frequenz hoeren wir?

s.options.blockSize;

s.sampleRate / s.options.blockSize; // 689.0625 Hz

{SinOsc.ar(s.sampleRate / s.options.blockSize) * 0.1}.play

{(1 / ControlDur.ir).poll}.play;

// block0 --> block1 --> block2 --> block3 --> .....
//   ^        ^   |       ^  |       ^  |
//   +--------|---+       +--|-------|--+
//            +--------------+       +--------


/////////////////////////////////////////////////////////////
// env --> loop

// aus der help-file
(
{
    EnvGen.kr(
        Env([0, 1, 0, 0.2, 0, 0.5, 0, 0.9, 0, 0.8, 0, 0], [0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01], loopNode: 1, releaseNode: 10),
        gate: Trig.kr(1, 0.95)
    );
}.plot(duration: 1)
)

// so koennen wir eine perkussive env loopen
// das 'tempo' entsteht durch die laenge der env
(
Ndef(\env, {
	EnvGen.kr(Env([0, 1, 0, 0], [0.01, 0.4], [1, -4], releaseNode: 2, loopNode: 0))
});
)

Ndef(\perc, {WhiteNoise.ar(Ndef(\env))});

// beispiel mit internem gate
(
Ndef(\env, {
	var impulse = LFPulse.ar(1);
	EnvGen.kr(Env([0, 1, 0, 0], [0.01, 0.4], [1, -4]), impulse);
});
)

// gate kann bei ndefs nicht als argument deklariert werden
// funktioniert nicht:
Ndef(\env1, {arg gate; EnvGen.kr(Env([0, 1, 0, 0], [0.01, 0.4], [1, -4]), gate);});
Ndef(\env1, {arg bla; EnvGen.kr(Env([0, 1, 0, 0], [0.01, 0.4], [1, -4]), bla);});
Ndef(\impulse, {LFPulse.ar(1);});
Ndef(\env1).map(\bla, Ndef(\impulse));

// funktioniert:
Ndef(\impulse, {LFPulse.kr(1);});
Ndef(\env2, {EnvGen.kr(Env([0, 1, 0, 0], [0.01, 0.4], [1, -4]), Ndef(\impulse));});

/////////////////////////////////////////////////////////////
// Ndefs und busse

Ndef(\sine, {arg freq = 440; SinOsc.ar(freq)});
Ndef(\sine).bus; // ndefs spielen immer auf automatisch zugewiesenen bussen

Ndef(\sine2, {arg freq = 440; SinOsc.ar(freq)});
Ndef(\sine2).bus;

Ndef(\sine1, {arg freq = 440; Out.ar(0, SinOsc.ar(freq))}); // mit "Out" wird diese automatische zuweisung ueberschrieben
Ndef(\sine1).bus;