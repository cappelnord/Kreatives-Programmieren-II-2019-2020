s.boot;

s.scope; // Von Tracks stellen auf X/Y

Ndef(\liss).fadeTime = 2

// Linie (in Phase)
Ndef(\liss, {SinOsc.ar(100 * [1, 1], [0, 0]) * 0.9}).play

// Kreis
Ndef(\liss, {SinOsc.ar(100 * [1, 1], [0, pi * 0.5]) * 0.9}).play

// Sich bewegender Kreis
Ndef(\liss, {SinOsc.ar(100 * [1, 1.001], [0, pi * 0.5])* 0.9}).play

// Bogen
Ndef(\liss, {SinOsc.ar(100 * [1, 2], [0, pi * 0.5]) * 0.9}).play

// ...

Ndef(\liss, {SinOsc.ar(100 * [1, 2.001], [0, pi * 0.5]) * 0.9}).play

Ndef(\liss, {SinOsc.ar(100 * [1, 3.001], [0, pi * 0.5]) * 0.9}).play

Ndef(\liss, {LFSaw.ar(100 * [1, 8.001], [0, pi * 0.5]) * 0.9}).play

Ndef(\liss, {[SinOsc.ar(100), LFSaw.ar(100 * 3.001)] * 0.9}).play

// ...


