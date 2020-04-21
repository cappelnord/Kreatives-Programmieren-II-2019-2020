// sonification

// csv --> comma separated values

// bsp: (so kann eine csv datei aussehen)
// Tierart, Anzahl
// Panda, 10
// Flamingo, 2



x = CSVFileReader.read(PathName(thisProcess.nowExecutingPath).pathOnly +/+ "pulsar_stars.csv");

// exkurs: dateien lesen
a = File.new("/Users/danielhopfner/Desktop/kp3/Kreatives-Programmieren-II-2019-2020/UEB3/12/test.txt", "r");
a.readAllString;

// back to csv:
x = CSVFileReader.read(PathName(thisProcess.nowExecutingPath).pathOnly +/+ "pulsar_stars.csv", startRow: 1);
// mit startRow können wir die erste zeite (deklaration der spalten) beim lesen weglassen

// leere zeilen löschen
x.removeAllSuchThat({arg item; item.size == 1});
x

// x ist gerade ein array voller strings
x[0][0].isString
x = x.asFloat; // in floats umwandeln

// wir wollen die matrix-klasse verwenden
Quarks.gui; // MathLib in der Liste suchen; '+'-symbol klicken; kurz warten; 'recompile class library' klicken
// nicht vergessen: alles nochmals ausführen, da wir mit 'recompile class library' den interpreter ge-resetted wurde

// eine matrix mit unserem array erzeugen
m = Matrix.with(x);

// matrix allgemein:
n = Matrix.with([[1, 2, 3], [4, 5, 6], [7, 8, 9]]);
n.flop;

// normalisieren (allgemein)
a = [1, 2, 3, 4, 2, -1, -6];
// variante: range ins positive "verschieben" (durch addition); danach normalisieren
a = a + a.minItem.abs;
a = a / a.maxItem;

(
// jede spalte im array normalisieren
m = m.flop;
m.shape[0].do{
	arg index;
	m.putRow(index, m.getRow(index) / m.getRow(index).maxItem);
};
)

m = m.flop;
m

// additive synthese
// 9 teiltöne steuern
(
SynthDef(\additive,
	{
		arg amps = #[1, 1, 1, 1, 0, 1, 0, 0, 1];
		var snd;
		snd = SinOsc.ar(Array.geom(9, 40, 1.6), mul: 1 / 9 * amps.lag).sum;
		Out.ar(0, Pan2.ar(snd));
	}
).add;
)

y = Synth(\additive);
y.setn(\amps, [1, 1, 1, 1, 1, 1, 1, 1, 1]);
y.setn(\amps, [0, 0, 0, 0, 0, 0, 0, 0, 0]);

(
fork{
	m.shape[0].do{
		arg index;
		y.setn(\amps, m.getRow(index));
		0.1.wait;
	}
}
)


(
SynthDef(\additive2,
	{
		arg freqs = #[50, 100, 150, 200, 250, 300, 350, 400, 450];
		var snd;
		snd = SinOsc.ar(freqs, mul: 1 / 9).sum;
		Out.ar(0, Pan2.ar(snd));
	}
).add;
)

y = Synth(\additive2);
y.setn(\freqs, Array.series(9, 40, 40));

(
fork{
	m.shape[0].do{
		arg index;
		y.setn(\freqs, m.getRow(index) * 3000 + 20);
		0.1.wait;
	}
}
)

// nachtrag:
// leere zeilen kann man auch beim datei-lesen direkt weglassen:
x = CSVFileReader.read(PathName(thisProcess.nowExecutingPath).pathOnly +/+ "pulsar_stars.csv", skipEmptyLines: true, startRow: 1); // siehe argument skipEmptyLines