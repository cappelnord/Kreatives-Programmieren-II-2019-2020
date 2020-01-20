// === Modular ===

// Funktionen zur modularen Komposition von SynthDefs

(
var osci = {|freq|
	Saw.ar(freq)
};

var superOsci = {|freq|
	Mix.ar(Saw.ar(freq * [1, 1.01, 2, 1.982])) * 0.25;
};

var ausgang = {|sig, pan, amp|
	Out.ar(0, Pan2.ar(sig * amp, pan));
};

SynthDef(\ok, {|freq=440, pan=0, amp=0.1|
	var sig = superOsci.value(freq);
	sig = RLPF.ar(sig, 880);
	ausgang.value(sig, pan, amp);
}).add;
)

Synth(\ok, [\freq, 50])


// Auf Node-Ebene können wir verschiedene Synths mit verschiedenen
// Rollen erzeugen und diese mit Bussen verbinden. Da dies aber manchmal
// etwas umständlich ist helfen uns Ndefs! Sie sind verwandt bzw. haben
// die gleiche Grundlage wie der ProxySpace.

Ndef(\ok, {|freq=440| Saw.ar(freq) * 0.1})
Ndef(\ok).play

Ndef(\ok).fadeTime = 2
Ndef(\ok, {|freq=440| Pulse.ar(freq) * 0.1})

Ndef(\ok).set(\freq, 50)

// Über den NdefMixer können wir Ndefs und ihre Parameter
// kontrollieren und mixen. Wir kriegen quasi ein GUI umsonst!

NdefMixer(s)

// Wir können Ndefs ineinander verschachteln!

Ndef(\lfo, {|freq=2| SinOsc.kr(freq).range(100, 500)})
Ndef(\ok, {|freq=440| Pulse.ar(Ndef(\lfo)) * 0.1})

Ndef(\lfo).set(\freq, 0.2)

Ndef(\ok).stop;

Ndef(\filter, {RLPF.ar(Ndef(\ok), 1000)})
Ndef(\filter).play

// Alternativ können wir auch Ndefs auf Parameter anderer Ndefs mappen

Ndef(\ok, {|freq=50| Saw.ar(freq) * 0.1})
Ndef(\ok).set(\freq, 100)
Ndef(\ok).map(\freq, Ndef(\lfo))

// Siehe auch:
// - Übung vom 14.11
// Help: Ndef und ProxySpace


// === Triggers ===

// Trigger-Signale sind .ar oder .kr Signale. Ein Trigger wird ausgelöst
// wenn das Signal aus dem negativen Wertebereich (oder von 0) ins positive
// wechselt.

// UGens die geeignete Trigger-Signale Erzeugen:
// Impulse, Dust, Changed, ...


( // Trigger um perkusivven Envelope zu triggern
Ndef(\trigger, {
	var env = EnvGen.ar(Env.perc(0.001, 0.5), Impulse.ar(2));
	SinOsc.ar(440) * env * 0.1;
})
)

Ndef(\trigger).play


( // Zusätzlich wird über einen Trigger noch ein Zufallsgenerator gesteuert
Ndef(\trigger, {
	var freq = TExpRand.kr(200, 800, Impulse.kr(0.5));
	var env = EnvGen.ar(Env.perc(0.001, 0.5), Impulse.ar(2));
	SinOsc.ar(freq) * env * 0.1;
})
)

s.latency = nil;

( // Mit Vergleichsoperationen lassen sich Trigger aus Signalen erzeugen
Ndef(\trigger, {
	var env = EnvGen.ar(Env.perc(0.001, 0.5), (Amplitude.kr(SoundIn.ar(0)).poll > 0.2));
	SinOsc.ar(440) * env;
}).play
)

( // Eine Vielzahl an UGens erlauben die Arbeit mit Triggern. Hier ein Versuch
  // das retriggern zu begrenzen. (Nicht mehr als 1 Trigger pro 50ms)
  // ... ich bin mir sicher das ginge auch etwas eleganter, funktioniert aber!
Ndef(\trigger, {
	var ampTrigger = (Amplitude.kr(SoundIn.ar(0)) > 0.2);
	var timeSinceLastTrigger = Sweep.kr(TDelay.kr(ampTrigger, SampleDur.ir*64)).poll;
	var trigger = ampTrigger & (timeSinceLastTrigger > 0.05);
	var env = EnvGen.ar(Env.perc(0.001, 0.5), trigger);
	SinOsc.ar(440) * env;
}).play
)


( // Stepper
Ndef(\trigger, {
	var trig = Impulse.kr(2);
	var freq = Stepper.kr(trig, 0, 50, 5000, 50);
	SinOsc.ar(freq) * 0.1;
}).play
)

( // Mit PulseDivider lassen sich mehrere Impulse von einem Grundmetrum ableiten
Ndef(\bumtschak, {
	var metrum = Impulse.ar(4);
	var hat = WhiteNoise.ar * EnvGen.ar(Env.perc(0.001, 0.01), metrum);
	var kick = SinOsc.ar(50) * EnvGen.ar(Env.perc(0.001, 1), PulseDivider.ar(metrum, 2));
	var snare = WhiteNoise.ar * EnvGen.ar(Env.perc(0.001, 0.1), PulseDivider.ar(DelayN.ar(metrum, 0.25, 0.25), 4));

	(kick + hat + snare);
}).play;
)


// === Feedback ===

// Aus technischer Sicht relevant: InFeedback und LocalIn/LocalOut

Quarks.gui

// Praktisch: Feedback Quark

Quarks.install("Feedback")

(
Ndef(\feedback, {
	var sig = BPF.ar(Dust.ar(10), MouseY.kr(50, 2000), 0.7);
	sig = FbC({|fb| RLPF.ar((sig + (fb*MouseX.kr(0.5, 3))).tanh, 2000)}, 0.25, 0.25);
	sig;
}).play;
)

// deutlich kürzere Feedback-Zeiten

(
Ndef(\feedback, {
	var sig = BPF.ar(Dust.ar(10), MouseY.kr(50, 2000), 0.7);
	sig = FbC({|fb| RLPF.ar((sig + (fb*MouseX.kr(0.5, 3))).tanh, 2000)}, 0.25, 0.025);
	sig;
}).play;
)


// Feedback mit Ndef

(
Ndef(\fb, {
	Dust.ar(1);
})
)

(
Ndef(\fb, {
	Dust.ar(1) + DelayC.ar(Ndef(\fb), 0.25, 0.25);
})
)

Ndef(\fb).play


// Mehr 'traditionelle' Feedback-Delays ...
// ... gleichzeitig auch ein Beispiel für Multichannel-Expansion und
// logische Operationen auf Trigger

(
Ndef(\pling, {
	var tempo = 1;
	var imp1 = Impulse.kr(tempo);
	var imp2 = Impulse.kr(tempo * 2);
	var imp3 = Impulse.kr(tempo * 2.5);

	var freqs = TExpRand.kr(200, 2000, [imp2, imp2 & imp1, imp3 & imp1]);
	// rundet auf nächste MIDI-Note
	var mFreqs = freqs.cpsmidi.round.midicps;

	var envs = EnvGen.ar(Env.perc(0.01, 1), [imp1 | imp3, imp3 & imp1, imp2 | imp3, imp1, imp2, imp3]);

	var sig = Splay.ar(envs * SinOsc.ar(mFreqs));
	(FbC({|fb| fb * 0.8 + sig}, 0.75, 0.75) + sig) * 0.2;
}).play;
)


( // PitchShift im Feedback ist auch ganz lustig
Ndef(\pling, {
	var tempo = 1;
	var imp1 = Impulse.kr(tempo);
	var imp2 = Impulse.kr(tempo * 2);
	var imp3 = Impulse.kr(tempo * 2.5);

	var freqs = TExpRand.kr(200, 2000, [imp2, imp2 & imp1, imp3 & imp1]);
	// rundet auf nächste MIDI-Note
	var mFreqs = freqs.cpsmidi.round.midicps;

	var envs = EnvGen.ar(Env.perc(0.01, 1), [imp1 | imp3, imp3 & imp1, imp2 | imp3, imp1, imp2, imp3]);

	var sig = Splay.ar(envs * SinOsc.ar(mFreqs));
	(FbC({|fb| PitchShift.ar(fb * 0.8 + sig, 0.2, 1.5) * 0.5 + fb * 0.5 + sig}, 0.75, 0.75) + sig) * 0.2;
}).play;
)

( // Oder Modulation der Feedback-Zeit
Ndef(\pling, {
	var tempo = 1;
	var imp1 = Impulse.kr(tempo);
	var imp2 = Impulse.kr(tempo * 2);
	var imp3 = Impulse.kr(tempo * 2.5);

	var freqs = TExpRand.kr(400, 4000, [imp2, imp2 & imp1, imp3 & imp1]);
	// rundet auf nächste MIDI-Note
	var mFreqs = freqs.cpsmidi.round.midicps;

	var envs = EnvGen.ar(Env.perc(0.01, 1), [imp1 | imp3, imp3 & imp1, imp2 | imp3, imp1, imp2, imp3]);

	var sig = Splay.ar(envs * SinOsc.ar(mFreqs));
	(FbC({|fb| PitchShift.ar(fb * 0.8 + sig, 0.2, 2) * 0.9 + fb * 0.5 + sig}, 0.75 * 2, 0.75 * LFNoise2.kr(0.1).range(0.5, 2)) + sig) * 0.2;
}).play;
)