MIDIClient.init;

// Nach dem Initialisieren von MIDI im 'Post Window' bei MIDI Destinations den
// Anschluss finden den ihr benutzen wollt (entweder Hardware oder interner MIDI Bus).
// Den Namen hier anpassen.

MIDIClient.destinations

// Die Namen hier anpassen.
m = MIDIOut.newByName("Microsoft GS Wavetable Synth", "Microsoft GS Wavetable Synth");

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

(
// Diese Funktion kann benutzt werden um eine Funktion zu erzeugen über die man
// MIDI-Noten mit einer bestimmten Länge triggern kann. Für den Fall, dass erneut eine
// Note mit der gleichen Nummer getriggert wird kann entweder die Note neu angeschlagen
// werden oder die Dauer verlängert werden.

// (Keine Sorge wenn ihr nicht alle Aspekte dieser Funktion versteht. Ihr dürft mich
// aber auch gerne nach Details fragen!)

c = {|destination, channel=0, retrigger=true|
	// Diesr Array beinhaltet Threads/Ko-Routinen zum Stoppen von MIDI-Noten
	var table = Array.fill(128, nil);

	// Diese Funktion wird zurückgegeben, mit ihr werden dann die Noten getriggert.
	{|num, vel=64, dur=1|

		// Prüfen ob noch eine alte Note mit selber Nummer läuft
		var routine = table[num];
		routine.isNil.if ({
			destination.noteOn(channel, num, vel);
		}, {
			// Stoppt die alte Ko-Routine; wird mit neuer überschrieben
			routine.stop;
			retrigger.if {
				destination.noteOff(channel, num, 64);
				destination.noteOn(channel, num, vel);
			};
		});

		// Diese Ko-Routine sendet am Ende das Note-Off
		table[num] = {
			dur.wait;
			destination.noteOff(channel, num, 64);
			table[num] = nil;
		}.fork(clock: TempoClock.default);
		dur;
	};
};
)

// Anwendungs-Beispiel
x = c.value(m, 0) // MIDI-Destination m, MIDI-Kanal 1
x.value(60, 64, 4) // Note 60, Velocity 64, Dauer 4

// Ohne Retrigger: Note wird um die neue Dauer verlängert wenn neu ausgeführt
x = c.value(m, 0, false);
x.value(60, 64, 4) // Note 60, Velocity 64, Dauer 4

// Zufalls-Gedudel als Beispiel
(
fork {
	inf.do {
		var octave = [3, 4, 5, 6].choose;
		var note = [0, 2, 4, 7, 9].choose;
		var num = octave * 12 + note;
		var dur = [0.25, 0.25, 0.5, 1].choose;
		var vel = 80.gauss(20).asInt;
		x.value(num, vel, dur);
		[0, 0, 0.125, 0.25, 0.5].choose.wait;
	}
};
)