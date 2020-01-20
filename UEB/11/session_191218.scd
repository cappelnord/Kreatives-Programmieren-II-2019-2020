// array.rotate

Array.series(20, 0, 1).rotate(3);

// wenn man eine periode einer wellenform in einem array hat, könnte
// man also auch .rotate verwenden, um die phase zu verschieben
Array.fill(2048, {arg i; sin(i / 2048 * 2 * pi + (pi / 2))}).plot
Array.fill(2048, {arg i; sin(i / 2048 * 2 * pi)}).rotate(-1 * (2048 / 4).asInt).plot


// verschiedene tonleitern hintereinander "ge-laced" mit ppatlace
(
var ser = Pseries(-1, -1, inf);
var n = 12;
var ae = 12;
Pdef(\pm,
	Pbind(
		\instrument, \ping,
		// \amp, 0.3,
		\amp, Pseq(((1 ! ae) ++ (0 ! (n - ae))).postln, inf) * 0.3,
		\dur, 1 / 8,
		\midinote, Ppatlace(n.collect({arg i; ser + Pseries(-1 * i, -1 * i, inf)}), inf) % 60 + 50
	)
).play;
)

// nachtrag: ndefs mit patterns steuern:

// aus help:
a = (degree: 3, sustain: 40).play;
fork { 10.do { (type: \set, id: a[\id], \degree: [0, 5, 8, 11].choose).play; 0.3.wait } };

// also brauchen wir die node-id von unserem ndef
Ndef(\test, {arg freq = 400; SinOsc.ar(freq)}).play;
Ndef(\test).nodeID;
Ndef(\test).asNodeID;

fork { 10.do { (type: \set, id: Ndef(\test).nodeID, \degree: [0, 5, 8, 11].choose).play; 0.3.wait } };

(
Pbind(
	\type, \set,
	\degree, Pxrand([0, 5, 8, 11], 10),
	\id, Ndef(\test).nodeID,
	\dur, 0.3
).play;
)

// funktioniert mit allen nodes:
{arg freq = 400; SinOsc.ar(freq) * 0.1}.play.nodeID;


// Pfsm:
(
Pbind(
	\midinote, (Pfsm(
		[
			[0, 1], // entry states
			0, [3, 3, 4, 4, 4, 4, 4, 1, 1], // wahrscheinlichkeit mit wiederholung beeinflussen
			3, [4],
			5, [0, 0, 5],
			7, [1],
			10, [2],
			nil, nil
		]
	) + 60)

).play;
)


(
Pfsm(
	[
		// entry
		[0, 2],
		// 0
		Pbind(\dur, Pseq([1, 1, 2, 1, 1, 2, 1, 1, 1, 1, 4]) / 4, \degree, Pseq([2, 2, 2, 2, 2, 2, 2, 4, 0, 1, 2])),
		[2],
		// 1
		Pbind(\dur, Pseq([2, 2, 1, 1, 1, 1, 2, 2], 2) / 4, \degree, Pseq([-3, 0, 0, 1, 0, -1, -2, -2, -2, 1, 1, 2, 1, 0, -1, -3])),
		[2],
		// 2
		Pbind(\dur, Pseq([1, 1, 1, 1, 2, 2, 1, 1, 2, 2, 1, 1, 2, 2, 2, 2]) / 4, \degree, Pseq([\, -3, 0, 0, 0, 1, 2, 2, 2, 2, 1, 2, 3, -1, 1, 0])),
		[0]
	]
).play;
)

// ideen:
// ppatlace mit den phrasen
// vorzeitig zum nächsten wechseln
// rückwärts spielen
// krebs (-umkehrung), etc.
// tonart wechsel