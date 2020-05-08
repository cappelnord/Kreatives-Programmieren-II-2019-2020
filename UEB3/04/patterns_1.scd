// Patterns in SuperCollider

// Hilfe: Pattern Guide
// Function > FuncStream > Routine > Pattern

// Funktion: { }
// .value

x = {|a, b| a + b};
x.value(10, 200)


(
// Closure ( https://de.wikipedia.org/wiki/Closure_(Funktion) )
// JavaScript, Lua, Lisp, Clojure

var n = 0;

x = {
	n = n + 1;
	n;
};

y = {
	n = 0;
};
)

x.value
y.value


// Streams erzeugen eine Reihe von Werten. Der nächste Wert wird mit next abgerufen

(
// FuncStream macht aus einer Funktion ein Stream
var n = 0;
x = FuncStream({
	n = n + 1;
	n;
});
);

x.next
x.nextN(10)


// Routinen können jederzeit unterbrochen werden. Mit 'yield' können Werte zurückgegeben werden.
// Beim nächsten Aufruf von .next wird die Routine dann fortgeführt (bis zum nächsten yield)

(
x = Routine({
	inf.do {
		4.do {
			10.yield;
		};
		2.do {
			20.yield;
		};
	}
});
)

x.next
x.nextN(10)

// Operationen (z.B. arithmetische Operationen) auf Streams erzeugen neue
// Streams, die die Operation in sich binden. (Dies funktioniert auch mit
// Funktionen !!)

a = x * 10; // x von oben, die Routine
a.next

b = {10.0.rand} * 2
b.value


// Patterns!

// Siehe auch: Pattern Guide 01: Introduction

// Patterns sind Blaupausen für Streams! Sie lassen sich miteinander
// kombinieren und verschachteln. Auch auf Patterns kann man arithmetische
// Operationen anwenden (sowohl um Patterns mit Patterns zu verrechnen als
// auch mit Konstanten). Patterns sind Zustandslos, es können beliebig viele
// unabhängige Streams aus Patterns erzeugt werden.

p = Pseq([10, 10, 10, 10, 20, 20], inf)
x = p.asStream; // erzeugt einen Stream aus dem Pattern

x.next
x.nextN(10)

p = Pseq([Pn(10, 4), Pn(20, 2)], inf) + Prand([1, 2, 3], inf)
x = p.asStream
y = p.asStream

// x und y sind voneinander unabhänngige Streams!

x.next
y.next

x.nextN(10)
y.nextN(10)

// Alle Objekte hören auf die next Nachricht (als Stream der
// konstant sich selber zurückgibt). Daher kann man auch überall
// wo ein Stream erwartet wird jegliche Konstante einsetzen.

5.next


// Events erlauben das komfortable Abspielen von SynthDefs

(
(
  degree: 0,
  instrument: \default
).play;
)

(
SynthDef(\pling, {|freq=440, amp=0.1, pan=0|
	var sig = SinOsc.ar(freq);
	sig = sig * EnvGen.ar(Env.perc(0.001, 1), doneAction:2);
	Out.ar(0, Pan2.ar(sig * amp, pan));
}).add;
)

// In einem Pbind werden die Ergebnisse der aus den Patterns erzeugten
// Streams in ein Event kombiniert und abgespielt. Das \dur Schlüsselwort
// steuert wie lange gewartet wird bis ein nächstes Event erzeugt wird.

(
x = Pbind(
	\instrument, \pling,
	\scale, Scale.minor,
	\degree, Pseq([0, 1, 2, 3, 4, 5, 6, 7], 3) + Pseq([0, 0, -2], 3),
	\octave, Pseq([5, 5, 4, 6, 5], 3),
	\dur, Prand([1/4, 1/4, Pn(1/16, 4)], 3)
);

y = Pbind(
	\instrument, \pling,
	\scale, Scale.minor,
	\degree, Prand([0, 1, 2, 3, 4, 5, 6, 7], 3) + Pseq([0, 0, -2], 3),
	\octave, 8,
	\dur, 1/4,
);

// mit Pseq und Ppar können mehrere Pbinds sequenziert werden

Pseq([x, y, Ppar([x, y]), Ppar([y, y, y], 4)], inf).play;
)


// Pbinds erzeugen Event Streams; Streams die Events zurückgeben

(
x = Pbind(
	\instrument, \pling,
	\scale, Scale.minor,
	\degree, Pseq([0, 1, 2, 3, 4, 5, 6, 7], 3) + Pseq([0, 0, -2], 3),
	\octave, Pseq([5, 5, 4, 6, 5], 3),
	\dur, Prand([1/4, 1/4, Pn(1/16, 4)], 3)
);
)

y = x.asStream
y.next(()).play