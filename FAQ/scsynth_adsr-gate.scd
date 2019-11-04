// ADSR Envelopes warten in der Sustain-Phase bis sie explizit
// beendet werden. Hierfür nutzt man den 'gate' Parameter.
// Siehe Hilfe: EnvGen

(
// gate ist zu Anfang 1 (offen)
// EnvGen geht in die Release-Phase sobald gate 0 (geschlossen)
SynthDef(\adsrTest, {|freq=440, gate=1, out=0, amp=0.1, pan=0|
	var sig = SinOsc.ar(freq);
	var env = EnvGen.kr(Env.adsr(0.01, 0.3, 0.5, 1.0), gate, doneAction: 2);
	Out.ar(out, Pan2.ar(sig * amp * env, pan));
}).add;
)

x = Synth(\adsrTest) // spielt immer weiter
x.set(\gate, 0) // geht in Sustain-Phase über

// Events setzen automatisch das gate auf 0 ..
// .. die Länge wird (unter anderem) über \dur gesteuert
(instrument: \adsrTest, dur: 1).play
(instrument: \adsrTest, dur: 0.25).play

// genauso in Patterns

(
Pbind(
	\instrument, \adsrTest,
	\degree, Pseq([0, 2, 4, 7], 4),
	\dur, 0.5
).play;
)

// über \legato kann man die Länge der Töne relativ zu \dur steuern

(
Pbind(
	\instrument, \adsrTest,
	\degree, Pseq([0, 2, 4, 7], 4),
	\dur, 0.5,
	\legato, 2 // Ton klingt doppelt so lang wie \dur
).play;
)

(
Pbind(
	\instrument, \adsrTest,
	\degree, Pseq([0, 2, 4, 7], 4),
	\dur, 0.5,
	\legato, 0.25 // Ton klingt nur 1/4 so lang wie \dur
).play;
)
