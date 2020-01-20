// WICHTIG; StageLimiter
Quarks.install("BatLib"); // danach neu kompilieren
StageLimiter.activate; // Setzt einen Limiter ans Ende der Signalkette


b = Buffer.read(s, "C:/Users/patri/Dropbox/Audiosamples/trump1.wav");
b.play;

Ndef(\maga).clear;

( // Kammfilter / Flanger
Ndef(\maga, {
	// var sig = PlayBuf.ar(1, b, loop: 1);
	var sig = WhiteNoise.ar;
	var delayedSig = DelayC.ar(sig, 0.01, MouseX.kr(0, 0.01));
	sig + delayedSig;
})
)

Ndef(\maga).play




( // Buffer 'Phasing'
Ndef(\maga, {
	Mix.ar(PlayBuf.ar(1, b, [1, 1.001], loop: 1)).dup * 0.5;
})
)

Ndef(\maga).play


( // Extreme Buffer 'Phasing'
Ndef(\maga, {
	var rates = 1 + (0.001,0.002..0.05);
	Mix.ar(PlayBuf.ar(1, b, rates, loop: 1)).dup / rates.size;
})
)

Ndef(\maga).play


// Schwebung
{(SinOsc.ar(440) + SinOsc.ar(441) * 0.5).dup}.play

// SuperSaw (verstimmmte obertonreiche Oszillatoren bringen Eigenleben)
(
{
	Mix.ar(Saw.ar(50 * [1, 1.001, 1.002])) / 3;
}.play
)

// Binaural Beat (mit Kopfhörer Versuchen)
{SinOsc.ar([440, 430]) * 0.1}.play

// Least Common Multiple
// (um zu Berechnen wann Muster verschiedener Länge sich wieder wiederholen)
3.lcm(4)
3.lcm(5)
12.lcm(15)


// ABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABC A
// ABCDABCDABCDABCDABCDABCDABCDABCDABCDABCDABCDABCDABCDABCDABCD A
// ABCDEABCDEABCDEABCDEABCDEABCDEABCDEABCDEABCDEABCDEABCDEABCDE A

// Oder:
(
Pbind(
	\degree, Pseq([0, 1, 2], inf),
	\dur, 0.5
).play;

Pbind(
	\degree, Pseq([0, 1, 2, 3], inf),
	\dur, 0.5
).play;

Pbind(
	\degree, Pseq([0, 1, 2, 3, 4], inf),
	\dur, 0.5
).play;
)


// Sinus Aliasing:
{SinOsc.ar(XLine.ar(50, 100000, 30).poll) * 0.1}.play

// Graphisches Aliasing (Fenstergröße Verändern)
{SinOsc.ar(880)}.plot(duration: 1)



( // Unterabtastung mit Latch / Sample&Hold
Ndef(\test, {
	var lfo = SinOsc.ar(0.5).range(200, 800);
	var freq = Latch.ar(lfo, Impulse.ar(MouseX.kr(0.5, 1)));

	SinOsc.ar(freq) * 0.1;
});

Ndef(\test).play

)

( // Unterabtastung einer Sinus-Funktion in einem Pattern (Steht still!)
Pdef(\okk, Pbind(
	\degree, ((Pseries(0, 1.0) * 2pi).sin * 8).round,
	\dur, 1
)).play;
)



