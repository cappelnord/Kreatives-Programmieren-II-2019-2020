// l-systeme

// klassiker:

// "A" -> "AB"
// "B" -> "A"

// B
// A
// AB
// ABA
// ABAAB
// ABAABABA
// ABAABABAABAAB

// implementierung mit dictionaries
(
~dict = Dictionary.new;
// ~dict.add(\A, "AB");
// ~dict.put(\A, "AB");
// ~dict.at(\A) = "AB";
~dict[\A] = "AB";
~dict[\B] = "A";
)

~dict = (\A: "AB", \B: "A");

(
~replace = {
	arg string, dict;
	var outString = "";
	string.do{
		arg char;
		var val = dict[char.asSymbol];
		val = (val.isNil).if({char}, {val});
		outString = outString ++ val;
	};
	outString;
}
)

a = "A";
a = ~replace.value(a, ~dict);

// no-name
a = "F-F-F-F";
~dict = (\F: "F-F+F+FF-F-F+F");
a = ~replace.value(a, ~dict);

// turtle quark installieren
Quarks.gui;

Turtle

(
~drawTurtle = {
	arg a, startPosition = 100@100, angle = pi / 3, len = 10;
	t = Turtle.new;
	t.init;
	t.to(startPosition);
	t.penDown;
	a.do{
		arg char;
		// (char == $F).postln;
		// char = char.asString;
		(char == $F).if({t.forward(len)});
		(char == $f).if({t.penUp; t.forward(len); t.penDown;});
		(char == $+).if({t.turn(angle)});
		(char == $-).if({t.turn(angle * -1)});
	};
	w = Window.new.front;
	w.drawFunc = {
		Pen.use {
			t.stroke;
		};
	};
	w.refresh;
}
)

// no-name
a = "F-F-F-F";
~dict = (\F: "F-F+F+FF-F-F+F");
a = ~replace.value(a, ~dict);
~drawTurtle.value(a, len: 10, startPosition: 10@100);

// koch
a = "F";
~dict = (\F: "F+F--F+F");
a = ~replace.value(a, ~dict);
~drawTurtle.value(a, len: 10, startPosition: 10@100);

// chars
$a ++ $b

// l-systeme mit Prewrite
(
a = Prewrite(
	\B, // anfangs-string
	(
		\A: #[\A, \B],
		\B: #[\A]
	), // dictionary mit regeln
	4 // anzahl der iterationen
);
a.asStream.nextN(30);
)

(
Pbind(
	\dur, Prewrite(2, (1: #[1, 2], 2: #[1]), 8) / 4; // A -> 1; B -> 2 || simple rhythm
).play;
)