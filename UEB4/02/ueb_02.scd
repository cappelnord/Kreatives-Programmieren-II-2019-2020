/* ========================================================

   -----------------------------------------------------
   Übungen zu Kreatives Programmieren 4: SuperCollider 2
   -----------------------------------------------------

   Sitzung 02 - 29.04.2020

======================================================== */



// --------------------------------------------
// Explicit osc-messaging to server with synths
// --------------------------------------------


// Plot node tree to monitor synths
s.plotTree;



// Example SynthDef 1 |  .add -> no defFile is written.

(
SynthDef(\xmpl, { | freq = 400 |
	var snd = SinOsc.ar(freq);
	Out.ar(0, snd * 0.5 !2)
}).add
)

// no explicit osc-messaging to server

x = Synth(\xmpl);
x.set(\freq, 500);
x.free;



// Example SynthDef 2  |  .writeDefFile -> Writes def as file readable by the server.
//                                         Must be manually (osc) loaded or by reboot.
//                                         Existing def files are loadaed automatically
//                                         at boot.


// Default location of def files is:
// Platform.userAppSupportDir ++ "/synthdefs/name-of-the-synth.scsyndef"


// open directory to monitor def files
(Platform.userAppSupportDir ++ "/synthdefs").openOS;


(
SynthDef(\xmpl2, { | freq = 400 |
	var snd = SinOsc.ar(freq);
	Out.ar(0, snd * 0.5 !2)
}).writeDefFile
)


// explicit osc-messaging to server


// load synth to server (for new SynthDefs / def files)
s.sendMsg("/d_load", Platform.userAppSupportDir ++ "/synthdefs/xmpl2.scsyndef");

// make new synth at node
s.sendMsg("/s_new", "xmpl2", 1000, 1, 0);

// set arguments of synth at node
s.sendMsg("/n_set", 1000, "freq", 700);

// free synth at node
s.sendMsg("n_free", 1000);



// ---------------------------------------------------------------------------



// ------------------------------------------
// Sending osc-messages from SC to Processing
// ------------------------------------------

/*

  Let's control the alpha value of a colored circle and its horizontal
  position in Processing with a sound source's amplitude and its position
  in the stereo field respectively.

  We'll be using an Envelope as a shared automation curve for the
  amplitude and panning position and emmbed it in a Pbind as a stream
  to send osc-messages to Processing.

*/



// Set the destination for osc-messages:
// localhost & port number

n = NetAddr("127.0.0.1", 12000); // Processing will listen to port 12000


// Define Synth

(
SynthDef(\ping, { |freq = 400, amp = 0, dur = 0.5, pan = 0|
	var snd, env;
	snd = SinOsc.ar(freq);
	env = EnvGen.kr(Env([0, 1, 1, 0], [0.01, dur - 0.02, 0.01]), doneAction: 2);
	snd = snd * env;
	Out.ar(0, Pan2.ar(snd, pan) * amp)
}).add
)


// Define Pbind

(
var env = Env([0, 1, 0], [5, 5], \lin); // define envelope

p = Pbind(
	\instrument, \ping,
	\freq, Pwhite(400, 600, inf), // some random freq for variation
	\amp, Pif(Ptime(inf) <= env.duration, env), // use Pif to stop the stream when the envelope ends -> see SC documentation: "Pattern Guide 06b: Time Based Patterns"
	\dur, 0.3,
	\pan, Pfunc( { |e| (e[\amp] - 0.5) * 2} ), // use Pfunc to get amp values and scale for panning (-1, 1)
	\osc, Pfunc( { |e| n.sendMsg("/alpha_pos", (e[\amp] * 255).asInteger, (e[\pan] * 200).asInteger); } ) // use Pfunc to get the amp values (scaled to 8-bit alpha range) and pan values (scaled to window size) and send osc-message to destination
);
)


p.play;
