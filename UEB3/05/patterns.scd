// Patterns speichern keinen Zustand
p = Pseries(start: 0, step: 2, length: inf);
q = p.asStream;
q.next;

r = p.asStream;
r.next; // unabhängig von q


j = Routine({inf.do{arg i; (i * 2).yield;}}); // Routine, die dasselbe macht, wie Pseries oben
j.next;



// Verschiedene Patterns


// list patterns

p = Pseq([4, 29, 8, 1], 2);
q = p.asStream;
q.next;
q.nextN(20);

p = Pser([4, 29, 8, 1], 2); // wie Pseq, nur dass 'repeats' die Anzahl der zurückgegebenen Werte bestimmt
q = p.asStream;
q.next;

p = Prand([4, 29, 8, 1], 8);
q = p.asStream;
q.next;

p = Pxrand([4, 29, 8, 1], 8); // wie Prand, nur wird kein Wert aus der Liste zweimal hintereinander zurückgegeben
q = p.asStream;
q.next;

p = Pwrand([4, 29, 8, 1], [0.1, 0.4, 0.2, 0.3], 8); // gewichtete Wahrscheinlichkeiten
p = Pwrand([4, 29, 8, 1], [1, 8, 2, 1].normalizeSum, 8); // normalizeSum sorgt dafür, dass die Summe aller Elemente im Array 1 ergibt
q = p.asStream;
q.next;

(
p = Place([
	[60],
	[72, 75],
	[48, 50, 52]], inf); // gibt immer das nächste Element aus der nächsten Liste aus
)
q = p.asStream;
q.nextN(20);
q.nextN(20).clump(3); // etwas übersichtlicher

(
Pbind(
	\freq, Place([[60], [72, 75], [48, 50, 52]].midicps, inf);
).play;
)


(
Pbind(
	\freq, Ppatlace([ // Ppatlace ist ähnlich zu Place, nur dass als Elemente in der Liste Patterns erwartet werden
		Pseq([60], inf),
		Pser([72, 75], inf),
		Pxrand([48, 50, 52], inf)
	], inf).midicps
).play;
)


// random patterns
p = Pwhite(0, 1, inf);
p = Pwhite(0.0, 1.0, inf);
q = p.asStream;
q.nextN(10).plot;
q.nextN(1000).histo.plot;

p = Pbrown(0.0, 1.0, step: 0.125, length: inf); // "drunk" walk
q = p.asStream;
q.nextN(10).plot(minval: 0, maxval: 1);

p = Pgauss(0.0, 1, inf);
q = p.asStream;
q.nextN(1000).histo.plot;


// filter patterns

// mit Pfindur kann man einen Pattern nach einer angegebenen Zeit beenden
Pfindur(4, Pbind(\dur, 0.5)).play; // richtet sich nach der TempoClock

TempoClock.default.tempo = 2;
Pfindur(4, Pbind(\dur, 0.5)).play;

// Padd addiert einen angegebenen Wert zum schon vorhandenen Wert des jeweiligen keys
Padd(\freq, 100, Pbind()).play;
Padd(\dur, 0.5, Pbind()).play;
Padd(\freq, Pseq([100, 200, 400], 1), Pbind()).play;
Padd(\freq, Pseq([100, 200, 400], inf), Pbind()).play;

// mit Pbindf kann Werte einzelne keys eines Patterns überschreiben
Pbindf(Pbind(), \freq, 100, \dur, 0.4, \legato, 0.01).play;


// Pbind und Pdef

// Pbind, Events und der \default-Synth
p = Pbind().play; // warum hören wir etwas, wenn wir einen leeren Pbind ausführen

(
p = Pbind(
	// \freq, 100,
).asStream; // wir können einen Pbind als Stream von Events ausgeben
)
p.next(()); // und dann diese Events mit .next abrufen
p.next(Event.new); // () <=> Event.new
p.next(Event.new).play; // und dieses Event auch abspielen
p.next(()).play; // mit .play sehen wir die default-Werte, die im Event schon gesetzt wurden

// event
().play;
Event.new.play;
(freq: 440).play;
(freq: 100)[\freq];

x = Synth(\default); // der default Synth ist in SuperCollider 'vorinstalliert'
x.set(\gate, 0);


// Beispiele mit Pbind
(
p = Pbind(
	\freq, Pseq([291, 1050, 512, 80, 420]),
	\dur, Pseq([2, 1.3, 3, 0.7, 0.1])
).play;
)

// Ppatlace in Aktion
(
Pbind(
	\freq, Ppatlace([
		Pseq([60], inf),
		Pser([72, 75], inf),
		Pxrand([48, 50, 52], inf)
	], inf).midicps,
).play;
)

(
Pbind(
	\midinote, Ppatlace([ // der 'midinote' key wird von Pbind umgerechnet - letztendlich wird dem Synth die entsprechende Frequenz übergeben
		Pseq([60], inf),
		Pser([72, 75], inf),
		Pxrand([48, 50, 52], inf)
	], inf),
).play;
)

(
Pbind( // Pbind berechnet aus 'degree' auch die entsprechenden 'midinote'-Werte
	\degree, Ppatlace([
		Pseq([0], inf),
		Pser([7, 8], inf),
		Pseq([-7, -6, -5], inf)
	], inf),
	\dur, Pgeom(2, 0.8, 20)
).play;
)

(
Pbind(
	\degree, Pseries(0, 1, 8), // einfache Tonleiter mit 'degree'
	\dur, 1/4
).play;
)

(
Pbind(
	\degree, 0,
	\sustain, 1, // sustain-Zeit
	\dur, Pgeom(2, 0.8, 20)
).play;
)
s.plotTree; // im Plot-Tree kann man auch gut die Überlappung der einzelnen Synths sehen

(
Pbind(
	\degree, 0,
	\legato, 0.5, // berechnet die sustain-Zeit in Abhängigkeit von 'dur'
	\dur, Pgeom(2, 0.8, 20)
).play;
)

// Pdef als Live-Coding Hilfe
(
Pdef(\meinPdef,
	Pbind(
		\freq, 100 // z.b frequenz ändern und danach nochmal ausführen, während es spielt - kein Cmd-. nötig
	)
).play;
)