# 06.11.2019; Kreatives Programmieren 3

Besprechung der Übungsprojekte.

## Zufalls-Projekt von Patrick

Grundlegende Idee war das Nutzen von Fotos (hier ein Bild eines Pilzes) als Wahrscheinlichkeitstabelle (effekt eine Funktion mit Parametern *x* und *y*). Durch die Kombination mit weiteren Funktionen kann die Wahrscheinlichkeit weiter beeinflusst werden, z.B. durch einen Filter der nur Töne einer bestimmten Skala zulässt oder eine Funktion die Grundtöne innerhalb eines harmonischen Spektrums bevorzugt. Mehrere paralell laufende Ko-Routinen versuchen in einem zufällig kombinierten Rhythmus per Monte-Carlo-Methode Klänge zu erzeugen.

Im Moment wird *x* als durchlaufende Zeit und *y* als Tonhöhe interpretiert. Natürlich könnte man dies auch anders gestalten.

Klangausgabe kann sowohl über MIDI als auch über einen FM-Synthesizer - inspiriert durch Ambient-Arbeiten von Brian Eno - geschehen.

* [SuperCollider Code](sparassis.scd)
* [Beispiel-Verteilung](sparassis-probability-example.png)
* ['Partitur'](sparassis-score.png)

## Weiteres

Abgabe der Projekte via Github-Repository und bei Bedarf Zusendung einer Audiodatei via E-Mail.