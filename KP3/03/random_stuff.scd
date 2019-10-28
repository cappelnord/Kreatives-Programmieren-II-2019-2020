// Zufall in sclang

// Siehe auch SCdoc: Randomness
// RNG: Random Number Generator

// Gleichmäßig verteilt
// Integers geben Integers; Floats ergeben Floats
5.rand;
5.0.rand;


// Zufall in einem bestimmten Berreich
5.0.rrand(10.0);
rrand(5.0, 10.0);


// Wahrscheinlichkeit nimmt linear von 0 aus ab.
10.linrand
1.0.linrand


// Unterschied ist in der Menge besser zu sehen.
20000.collect({100.0.rand}).plot
20000.collect({100.0.linrand}).plot

// Alternative: Array.fill


// Noch besser zu sehen mit Histogrammen!
200000.collect({100.0.rand}).histo.plot
200000.collect({100.0.linrand}).histo.plot


// 'bipolare' Zufallswerte
5.0.rand2;
10.0.bilinrand;
200000.collect({100.0.bilinrand}).histo.plot


// Exponentiell verteilte Zufallswerte
200000.collect({exprand(0.01, 1)}).histo.plot
exprand(0.01, 1);


// Zufallswerte mit Normalverteilung
100.0.gauss(1) // Argument 1: Standardabweichung von 1.

// Gauss-ähnliche Verteilung
100.0.sum3rand

200000.collect({100.0.sum3rand}).histo.plot
200000.collect({100.0.gauss(20)}).histo.plot


// In den SC3plugins (ProbabilityDistributions.sc) gibt es
// noch weitere Verteiluingen, z.B. Cauchy, Poisson


// Random Seed (jeweils für jeden Thread)
// Nach Setzen des Seeds werden jeweils immer die gleichen Werte erzeugt.

thisThread.randSeed = 1234;
5.rand;
5.rand;
5.rand;

// Internas:
// SuperCollider benutzt taus88 als Zufallsgenerator.

// Einblick in den aktuellen Zustand des Zufallsgenerators
x = thisThread.randData;

// Der Zustand des RNG könnte auch wieder 'zurückgespult' werden
thisThread.randData = x


(
thisThread.randSeed = 10;
fork {
	thisThread.randSeed = 10;
	5.rand.postln;
	0.5.wait;
	5.rand.postln;
	0.5.wait;
	5.rand.postln;
};
)

// nach dem Ausführen des oberen Codeblocks, mit dem selben Seed aber einem
// eigenen RNG, sollten die gleichen 3 Ganzzahlen erzeugt werden. Entfernt
// man die Zuweisung des Seeds in der fork dann wird in beiden Threads der
// gleiche RNG benutzt (die gewürfelten Werte sind nicht mehr gleich).

5.rand;
5.rand;
5.rand;

// wieder mit dem aktuellen Datum seeden
thisThread.randSeed = Date.seed



// Zufall in scsynth

// Rand
// LFNoise, andere Noises
// RandSeed
// RandID
// ...


(
// Die sclang-Methoden rand und exprand werden nur bei der Kompilierung des
// SynthDefs ausgeführt. Die Zahl bleibt daher innerhalb des SynthDefs konstant
// und ändert sich nur wenn der SynthDef neu kompiliert wird.

SynthDef(\ping, {
	var sig;
	sig = SinOsc.ar(exprand(110, 440));
	sig = sig * EnvGen.ar(Env.perc(0.001, 1), doneAction:2);
	Out.ar(0, sig.dup * 0.1);
}).add;
)
Synth(\ping);


(
// Rand und ExpRand wird auf dem Server ausgeführt, jedes mal wenn der Synth
// instanziert wird.

SynthDef(\ping, {
	var sig;
	sig = SinOsc.ar(ExpRand(110, 440));
	sig = sig * EnvGen.ar(Env.perc(0.001, 1), doneAction:2);
	Out.ar(0, sig.dup * 0.1);
}).add;
)
Synth(\ping);


(

// Hier wird der Random Seed auf dem Server bei jedem Instanzieren wieder zurückgesetzt.
// Dadurch erklingt jedes mal die gleiche Frequenz.

SynthDef(\ping, {
	var sig;
	RandSeed.kr(1, 1203);
	sig = SinOsc.ar(ExpRand(110, 440));
	sig = sig * EnvGen.ar(Env.perc(0.001, 1), doneAction:2);
	Out.ar(0, sig.dup * 0.1);
}).add;
)
Synth(\ping)


// Zwei mal Weißes Rauschen jeweils auf seperaten RNGs mit gleichem Seed und
// invertierter Polarität. Das Ergebnis ist (hoffentlich) Stille :-).

(
SynthDef(\name, {|id=10, amp=0.1|
	RandID.kr(id);
	RandSeed.kr(1, 500);
	Out.ar(0, WhiteNoise.ar * amp);
}).add;
)

(
(\instrument: \name, \id: 10, \amp: 0.1).play;
(\instrument: \name, \id: 11, \amp: -0.1).play;
)


// Weitere Techniken

// Branching: Über einen Größenvergleich kann man einfach eine
// Entscheidung mit einer gewissen Wahrscheinlichkeit programmieren.

(
(1.0.rand > 0.3).if({
	"Hip".postln;
}, {
	"Pop".postln;
});
)


// .coin macht die Sache noch etwas handlicher
(
0.7.coin.if({
	().play;
});
)


// Zufall kann natürlich auch in bedingten Schleifen angewandt werden
(
fork {
	{1.0.rand > 0.01}.while({
		().play;
		0.1.wait;
	});
}
)


// Auswahl eines zufälligen Elemnts aus einer Liste
[1, 2, 3].choose

// prinzipiell: [1, 2, 3][3.rand]

// Durch doppelte Werte kann man sehr einfach gewichten
[1, 1, 2, 3].choose

// mit wchoose kann man auch selber Gewichtungen angeben
[1, 2, 3].wchoose([0.5, 0.25, 0.25])


// scramble durchmischt Listen/Arrays
[1, 2, 3, 4, 5, 6].scramble

// Lottozahlen: 6 aus 49
(1..49).scramble[0..5]


// Random Walks

(
var x = 1.0;
r = {
	x = x + 0.05.rand2;
	x;
}
)

r.value
1000.collect(r).plot



// beliebige Zufallsverteilung (Beispiel aus SCdoc: Randomness)

(
var randomNumbers, histogram, distribution, randomTable, randTableSize=200;
var minValue = -250, maxValue = 250, numVals = 1000000, numBins = 500;

// create some random distribution with values between 0 and 1
distribution = Array.fill(randTableSize,
    { arg i; (i/ randTableSize * 35).sin.max(0) * (i / randTableSize) }
);

// render a randomTable
randomTable = distribution.asRandomTable;

// get random numbers, scale them

randomNumbers = Array.fill(numVals, { randomTable.tableRand * (maxValue - minValue) + minValue; });
histogram = randomNumbers.histo(numBins, minValue, maxValue);


histogram.plot("this is the histogram we got");
distribution.plot("this was the histogram we wanted");
)

