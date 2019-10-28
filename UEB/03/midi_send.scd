MIDIClient.init;

// Nach dem Initialisieren von MIDI im 'Post Window' bei MIDI Destinations den
// Anschluss finden den ihr benutzen wollt (entweder Hardware oder interner MIDI Bus).
// Den Namen hier anpassen.

MIDIClient.destinations

// Die Namen hier anpassen.
m = MIDIOut.newByName("Microsoft GS Wavetable Synth", "Microsoft GS Wavetable Synth");

// Dies sendet auf MIDI-Kanal 1. (SuperCollider beginnt bei der Nummerierung mit 0)
m.noteOn(0, 60, 64);
m.noteOff(0, 60, 64);

// SCDoc: MIDIOut

m.control(0, 64, 100);

(
// Panic Button, Sendet Note-Off Nachrichten an alle Noten
fork {
	128.do {|n|
		m.noteOff(0, n, 64);
		0.001.wait;
	};
}
)

// PRAKTISCH: Dies einmal ausführen, dann wird jedes mal wenn ihr Strg. bzw. Cmd. ausführt
// Auch die Note-Off Nachrichten geschickt.
(
CmdPeriod.add({
	"MIDI Note-Off".postln;
	fork {
		128.do {|n|
			m.noteOff(0, n, 64);
			0.001.wait;
		};
	}
});
)

// Setzen des Tempos (in Beats per Seconds)
TempoClock.default.beats = 2; // 120 BPM


// Einige Beispiele mit MIDI und Zufall

(
fork {
	inf.do {
		var note = [60, 62, 64, 65].choose;
		m.noteOn(0, note, 64);
		{m.noteOff(0, note,64)}.defer(2);
		[0.25, 0.25, 0.5].choose.wait;
	};
}
)

// Ein komplexeres Beispiel:
// Aus einem Array mit Funktionen die jeweils kleine zufällige Sequenzen
// darstellen wird zufällig gewählt.

(
var line = Routine({
	var x = 0;
	inf.do {
		x = x + [-1, 0, 1].choose;
		x.yield;
		0.2.coin.if {
			x = x + [-12, 12].choose;
		};
		x.yield;
	};
});

var x = 60;
var randomWalk = {
	x = x + 3.rand2;
	x;
};

var channel = 0;

d = [
	{
		"A".postln;
		16.do {
			var note = randomWalk.value;
			m.noteOn(channel, note, 64);
			{m.noteOff(channel, note,64)}.defer(2);
			[0.25, 0.25, 0.5].choose.wait;
		}
	}, {
		"B".postln;
		4.do {
			var note = [60, 62, 64, 65].choose;
			m.noteOn(channel, note, 64);
			{m.noteOff(channel, note,64)}.defer(2);
			[0.25, 0.25, 0.5].choose.wait;
		}
	}, {
		"L".postln;
		12.do {
			var note = 64 + line.next;
			m.noteOn(channel, note, 64);
			{m.noteOff(channel, note,64)}.defer(2);
			0.125.wait;
		}
	}
];

fork {
	inf.do {
		d.choose.value;
	}
}
)
