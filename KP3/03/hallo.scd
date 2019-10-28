// Der Dozent musste sich um korrekte Lichtverhältnisse und Belüftung kümmern.
// Er wartet bis die letzen Studierenden eintreffen und/oder zur Ruhe kommen.

(
fork {
	rrand(10, 40).wait;
	"Los geht's!".postln;
};
)

// Er begrüßt die Studierenden ..

(
[
	"Schön, dass ihr wieder da seid!",
	"Jo jo jo ...",
	"Hallo zusammen!"
].choose.postln;

"Herzlich Willkommen zu Kreatives Programmieren 3!".postln;
)

// ... in seiner wohlbekannten Verwirrtheit verhaspelt er sich etwas ...

(
var haspeln = ["Ääh ...", "Mh ...", "Wir ...", "Unser ..", "Also ...", "*Zischlaut*", "*Genervtes Ausatmen*"];

fork {
	(7 + 12.rand).do {
		haspeln.choose.postln;
		rrand(0.8, 1.2).wait;
	};
	".".postln;
};
)

"Moment ...".postln;

// ... er muss sich erstmal vergewissern um was es hier eigentlich geht ...

(
"Der Lehrer öffnet Google, sucht nach ".post;
["John Cage", "Coprinus comatus", "Zufallsgeneratoren", "HfM Karlsruhe"].choose.post;
0.5.coin.if {", vertippt sich dabei".post;};
(" und klickt auf den " ++ (1 + 3.rand) ++ ". Link.").postln;
"".postln;
)

// ... nach einer Weile ist er sich aber wieder sicher um was es geht:

(
var thema = 0.01.coin.if("Mykologie", "Zufall");
("Unser heutiges Thema ist: " ++ thema).postln;
)
