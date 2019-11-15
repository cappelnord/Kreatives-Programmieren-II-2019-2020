MIDIClient.init
MIDIIn.connectAll

(
MIDIdef.noteOn(\allOn, {|val, num, chan, src|
	[val, num, chan, src].postln;
});

MIDIdef.noteOn(\allOff, {|val, num, chan, src|
	[val, num, chan, src].postln;
});
)