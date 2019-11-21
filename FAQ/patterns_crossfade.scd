// Crossfades von Patterns

// PfadeOut und PfadeIn sind 2 undokumentierte Filter-Pattern-Objekte
// für Event Streams.

(
a = Pbind(\dur, 1, \degree, Pseq([7], 4))
b = Pbind(\dur, 1, \degree, Pseq([0], 4))

Pseq([
	a,
	Ppar([PfadeOut(a, 4), PfadeIn(b, 4)]),
	b
]).play
)

(
// Falls die Pattern unendlich lange laufen ...
a = Pbind(\dur, 1, \degree, Pseq([7], inf))
b = Pbind(\dur, 1, \degree, Pseq([0], inf))

// ... kann man die Pattern z.B. mit Pfindur zeitlich begrenzen.
Pseq([
	Pfindur(8, a),
	Pfindur(4, Ppar([PfadeOut(a, 4), PfadeIn(b, 4)])),
	Pfindur(8, b)
]).play;
)


// Crossfades von Patterns sind auch im ProxySpace möglich
p = ProxySpace.push(s.boot);

~pattern.fadeTime = 4;
~pattern.quant = 4;
~pattern = Pbind(\dur, 1, \degree, Pseq([7], inf));
~pattern.play;
~pattern = Pbind(\dur, 1, \degree, Pseq([0], inf));
