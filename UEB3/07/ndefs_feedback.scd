// feedback über lautsprecher und mikrofon
Ndef(\feedback, {SoundIn.ar(0, mul: MouseX.kr(0, 1))});
Ndef(\feedback).play;

// software-internes feedback
(
Ndef(\feedback, {
	Dust2.ar(18) + // irgendeine klangquelle
	(
		DelayC.ar(Ndef.ar(\feedback), 0.2, 0.05) // output vom ndef im
												 // ndef selbst
												 // verwenden (-->
												 // feedback)
		* MouseX.kr(0.3, 1.1) // amplitude regulieren mit mousex
	).tanh
});
)

//                                         /|
// +------+      -----                  +-+ |
// | Dust |---->(  +  )-----------o-----| | |
// +------+      -----            |     +-+ |
//                 ^              |        \|
//                 |              |
//                 |              |
//                 |   +-----+    |
//                 +---|Delay|<---+
//                     +-----+



(
Ndef(\feedback, {
	Dust.ar(18) +
	(
		DelayC.ar(
			Ndef(\feedback),
			0.2,
			MouseY.kr(0.001, 0.1)) // delaytime mit mousey
								   // kontrollieren
	* MouseX.kr(0.3, 1.1)).tanh
});
)

NdefMixer(s);
// oder:
n = NdefMixer(s); n.parent.alwaysOnTop = true;

// effekt-chain: feedback -> filter
Ndef(\filter, {arg freq = 200; RLPF.ar(Ndef(\feedback), freq, 0.1)});

// filter-freq mit lfo modulieren
Ndef(\lfo, {LFNoise2.ar(1).range(100, 1000)});
Ndef(\filter).map(\freq, Ndef(\lfo)); // kann man auch erreichen, wenn
									  // man im ndef-mixer mit der
									  // maus den lfo auf den
									  // freq-parameter vom filter
									  // zieht


s.options.blockSize;
// feedback ist (so wie wir es hier gemacht haben) an die blocksize
// gebunden.
Ndef(\feedback, {Dust.ar(18) + (Ndef(\feedback) * MouseX.kr(0.3, 1.1)).tanh});
Ndef(\blocksize, {SinOsc.ar(s.sampleRate / s.options.blockSize) * 0.3}).play;


// note:
// ndefs laufen immer im hintergrund.
s.plotTree;
// sie werden "hoerbar, wenn wir '.play' aufrufen (--> ein
// monitor-ugen routet audio vom ndef auf bus 0)