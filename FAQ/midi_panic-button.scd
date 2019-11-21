MIDIClient.init;
MIDIClient.destinations;

// Hier anstatt "..." die Infos aus MIDIClient.destinations angeben
m = MIDIOut.newByName("...", "...");

( // nur einmal ausführen
CmdPeriod.add({
	"MIDI Panic".postln;
	fork {
		[0].do {|c| // hier in die Liste alle Kanäle eintragen die genutzt werden
			128.do {|n|
				m.noteOff(c, n, 64);
				0.0001.wait;
			};
		}
	}
});
)