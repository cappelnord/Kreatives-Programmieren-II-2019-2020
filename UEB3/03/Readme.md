# 23.10.2019; Übung zu Kreatives Programmieren 3

## Interne MIDI-Busse

Es existieren viele Möglichkeiten um MIDI-Daten von einer Applikation zu einer anderen zu schicken. Hier zwei Möglichkeiten mit denen ich gute Erfahrungen gesammelt habe. Benutzt gerne jegliches andere Tool!

### MacOS: IAC Busse

Apple bringt bereits alles mit was man braucht. Interne MIDI-Busse verstecken sich in der Applikation *Audio MIDI Setup*.

[Anleitung bei Apple](https://support.apple.com/de-de/guide/audio-midi-setup/ams1013/mac)

### Windows: [loopMIDI](http://www.tobias-erichsen.de/software/loopmidi.html)

## MIDI Daten aus SuperCollider senden

Der erarbeitete Quelltext ist in [midi_send.scd](midi_send.scd). Der Code ist auch in [task_01_template.scd](../../KP3/03/task_01_template.scd) eingeflossen.

### Relevante Seiten in SCDoc

* [Using MIDI](http://doc.sccode.org/Guides/UsingMIDI.html)
* [MIDI](http://doc.sccode.org/Guides/MIDI.html)
* [MIDIOut](http://doc.sccode.org/Classes/MIDIOut.html)
