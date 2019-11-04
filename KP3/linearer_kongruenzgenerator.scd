/*
Linearer Kongruenzgenerator

Algorithmus :
x = (a * x + c) % m;


Argumente:

x(n) Startwert/seed x(0) bzw. nächse "Zufallszahl"
m modulus
a multiplikator
c steigung


Voraussetzungen:

0<= a <m
0<= c <m
0<= x(o) < m


Beispielberechnung für den Parametersatz

x(0) = 4
a = 3
m = 12
c = 2

x(1) = (3 * 4 + 2) % 12
x(1)= 14 % 12
x(1) = 2

--> x(1) = 2 ist der nächste Wertt der Zufallszahlenfolge.
Um den darauffolgenden Wert zu ermitteln setzt man x = 2 wieder in die Formel ein etc..

x(2) = (3 * 2 + 2) % 12
x(2) = 8 % 12
x(2) = 8

*/


// Implementierung des Algorithmus innerhalb einer Funktion

(
f = { arg x, a, c, m;
	{
		x = (a * x + c) % m;
		x;
	}
};
)


// Mit Hilfe von Closures werden Zustand und Parameter an eine Funktion gebunden

d = f.value(7, 21, 3, 17);
d.value;


// Zwei unterschiedliche Parametersätze zur Demonstration von einer kurzen / bzw. einer langen Periode

d = f.value(7, 21, 3, 17);
d = f.value(12, 65539, 0, 2**31);


// Plots und Histogramme

100.collect(d).plot
100.collect(x).histo.plot


// Ausgabe von 100 Zufallswerten

(
100.do {
	d.value.postln;
}
)



