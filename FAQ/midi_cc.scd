// Steuern von Parametern mit MIDI CC
// Siehe: MIDIdef

MIDIClient.init;

// siehe MIDIIn falls nicht alle Interfaces verbunden werden sollen
MIDIIn.connectAll;

// In den meisten Fällen macht es Sinn die Server-Latenz auf nil
// zu stellen. Dadurch gibt es keine Wartezeit zwischen setzen
// von Parametern und Änderung des Klangs.
s.latency = nil;


( // Jeder MIDIdef hat einen eindeutigen Namen. Wird ein
  // MIDIdef mit gleichem Namen noch mal ausgeführt ersetzt
  // er den Alten.
MIDIdef.cc(\all, {
	"CC!".postln;
});
)

( // Gibt alle eingehenden MIDI-CC Nachrichten aus
MIDIdef.cc(\all, {|val, num, chan, src|
	[val, num, chan, src].postln;
});
)
MIDIdef(\all).clear

( // MIDIdef erlaubt das Filtern von Nachrichten.
  // Dieser MIDIdef wird nur für CC Nr. 5 auf
  // MIDI-Kanal 1 (in SuperCollider: 0) ausgeführt.
MIDIdef.cc(\one, {|val, num, chan, src|
	[val, num, chan, src].postln;
}, 5, 0)
)
MIDIdef.cc(\one).clear



// === 1) Steuern von Synth-Parametern ===

(
SynthDef(\bass, {|freq=100, amp=0.1, out=0, pan=0|
	var sig = RLPF.ar(Saw.ar(freq), SinOsc.kr(0.9).range(1000, 2000), 0.8);
	Out.ar(out, Pan2.ar(sig * amp, pan));
}).add;
)

x = Synth(\bass)


( // Jeder MIDIdef hat einen eindeutigen Namen (hier \freq)
  // Die Funktion wird bei jeder eintreffenden MIDI-Nachricht ausgeführt
MIDIdef.cc(\freq, {|val, num, chan, src|
	x.set(\freq, val.linexp(0, 127, 50, 800));
}, 5); // Hört nur auf MIDI-CC Nr. 5; hier anpassen!
)

// linlin, linexp, explin und expexp sind sehr praktische Funktionen
// zum Mappen von einem Wertebereich in den anderen.
// Siehe: http://doc.sccode.org/Classes/SimpleNumber.html#-linlin

// Bei den hohen Frequenzen hören wir die geringe Auflösung von MIDI!
// Oftmals kann man sich hier helfen indem man den Parameter glättet.
// Siehe: Lag2


(
SynthDef(\bass, {|freq=100, amp=0.1, out=0, pan=0|
	var sig = RLPF.ar(Saw.ar(Lag2.kr(freq, 0.1)), SinOsc.kr(0.9).range(1000, 2000), 0.8);
	Out.ar(out, Pan2.ar(sig * amp, pan));
}).add;
)

x = Synth(\bass)


// === 2) Steuern von Ndefs ===

// === A) Steuern von Parametern ===

(
Ndef(\bass, {|freq=440|
	var sig = RLPF.ar(Saw.ar(Lag2.kr(freq, 0.1)), SinOsc.kr(0.9).range(1000, 2000), 0.8);
	(sig * 0.1).dup
});
)

Ndef(\bass).play


(
MIDIdef.cc(\freq, {|val, num, chan, src|
	Ndef(\bass).set(\freq, val.linexp(0, 127, 50, 800));
}, 5);
)

// Sehr praktisch ist, dass selbst beim Ausführen eines neuen Ndefs der alte Wert
// gespeichert bleibt.

(
Ndef(\bass, {|freq=440|
	var sig = RLPF.ar(Pulse.ar(Lag2.kr(freq, 0.1)), SinOsc.kr(0.9).range(1000, 2000), 0.8);
	(sig * 0.1).dup
});
)

// Alternative Schreibweise mit NamedControls

( // hier ohne Lag
Ndef(\bass, {
	var sig = RLPF.ar(Pulse.ar(\freq.kr(440)), SinOsc.kr(0.9).range(1000, 2000), 0.8);
	(sig * 0.1).dup
});
)

( // Lag kann automatisch als weiteres Argument der NamedControl angegeben werden
Ndef(\bass, {
	var sig = RLPF.ar(Pulse.ar(\freq.kr(440, 0.1)), SinOsc.kr(0.9).range(1000, 2000), 0.8);
	(sig * 0.1).dup
});
)


// === B) Ndefs als Platzhalter für Werte ===

( // Lag kann automatisch als weiteres Argument der NamedControl angegeben werden
Ndef(\bass, {
	var sig = RLPF.ar(Pulse.ar(Ndef(\freq).kr), SinOsc.kr(0.9).range(1000, 2000), 0.8);
	(sig * 0.1).dup
});
)

Ndef(\freq, 400)

Ndef(\bass).play

(
MIDIdef.cc(\freq, {|val, num, chan, src|
	Ndef(\freq, val.linexp(0, 127, 50, 800));
}, 5);
)

// Dies ist nicht unbedingt der flexibelste Ansatz ...
// ... vielleicht wäre dies sogar ein bisschen flexibler.

Ndef(\freq, {|value=440| Lag2.kr(value, 1)})

(
MIDIdef.cc(\freq, {|val, num, chan, src|
	Ndef(\freq).set(\value, val.linexp(0, 127, 50, 800));
}, 5);
)

// === 3) Busse ===

// Natürlich kann man auch .kr Busse benutzen

b = Bus.control(s, 1);
b.set(440)

(
{
	RLPF.ar(Pulse.ar(Lag2.kr(In.kr(b, 1), 0.1)), SinOsc.kr(0.9).range(1000, 2000), 0.8).dup * 0.1
}.play;
)

(
MIDIdef.cc(\freq, {|val, num, chan, src|
	b.set(val.linexp(0, 127, 50, 800));
}, 5);
)


// === 3) MIDIdef und GUI ===

// Wenn man kein Feedback an die MIDI-Controller schicken mag ist valueAction ein guter Weg
// um gleichzeitig GUI-Elemente zu steuern (auch als visuelles Feedback) und Synths zu steuern
// (das wollen wir am Ende ja)

(
var window = Window.new("Test", 200@200);
var knob = Knob(window, Rect(25, 25, 150, 150));

// alternativ EZKnob welcher die ControlSpec
// und ein Label bereits beinhaltet.
var cs = ControlSpec(200, 1600, \exponential);

var sound = {|freq=200| SinOsc.ar(freq).dup * 0.1}.play;

knob.action_({|x|
	sound.set(\freq, cs.map(x.value));
});

MIDIdef.cc(\freq, {|val, num, chan, src|
	// normalisiert MIDI-Werte
	knob.valueAction = val.linlin(0.0, 127.0, 0.0, 1.0);
}, 5); // CC 5

window.front;

// nur um unten damit zu spielen ...
k = knob;
c = cs;
)

k.valueAction = 0.2;
k.valueAction = c.unmap(440)
