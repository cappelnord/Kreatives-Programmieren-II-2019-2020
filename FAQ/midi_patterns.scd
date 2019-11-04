// Siehe auch Hilfe - Pattern Guide Cookbook 04: Sending MIDI
// http://doc.sccode.org/Tutorials/A-Practical-Guide/PG_Cookbook04_Sending_MIDI.html

MIDIClient.init;
MIDIClient.destinations;

// Hier anstatt "..." die Infos aus MIDIClient.destinations angeben
m = MIDIOut.newByName("...", "...");

// Testen einer MIDI Note
m.noteOn(0, 60, 64);
m.noteOff(0, 60, 64);

(
Pbind(
	\type, \midi, // sendet automatisch noteOn & noteOff Nachrichten
	\midiout, m,
	\chan, 0, // MIDI-Kanal 1
	\degree, Pseq([0, 2, 4, 7], inf),
	\dur, 1,
	\amp, 0.6 // wird in Velocity Werte übersetzt
).play;
)
