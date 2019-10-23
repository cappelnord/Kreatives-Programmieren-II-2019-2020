// Zufall in sclang

// Gleichmäßig verteilt
// Integers geben Integers; Floats ergeben Floats

5.rand;
5.0.rand;

// Wahrscheinlichkeit nimmt linear von 0 aus ab.
10.linrand
1.0.linrand

// Unterschied an Hand einzelner Werte unmöglich zu sehen!

20000.collect({100.0.rand}).plot
20000.collect({100.0.linrand}).plot

// Noch besser zu sehen mit Histogrammen!

20000.collect({100.0.rand}).histo.plot
20000.collect({100.0.linrand}).histo.plot

// 'bipolare' Zufallswerte

5.0.rand2;
10.0.bilinrand;

// Zufall in einem bestimmten Berreich

5.0.rrand(10.0);
rrand(5.0, 10.0);

exprand(0.01, 1);


// Verteilungen

100.0.sum3rand
100.0.gauss(1)


// => Siehe auch SC3plugins ProbabilityDistributions.sc
// Cauchy, Poisson

// Random Seed (jeweils für jeden Thread)

thisThread.randSeed = 1234;

// fork/Routines, Vererbung des Seeds



// Internas:
// SuperCollider benutzt taus88 als Zufallsgenerator.

// Einblick in den aktuellen Zustand des Zufallsgenerators
thisThread.randData;

// Weitere Techniken

// choose
// coin
// scramble
// random walk (TODO)
// Ausdrücke in Funktionen packen


// Zufall in scsynth

// Rand
// LFNoise, andere Noises
// RandSeed
// RandID
// => {}.play racing condition
// ...



