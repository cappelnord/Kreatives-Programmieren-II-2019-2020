/* ========================================================

   -----------------------------------------------------
   Übungen zu Kreatives Programmieren 4: SuperCollider 2
   -----------------------------------------------------

   Sitzung 04 - 13.05.2020

======================================================== */


// Network-Info Utilities

NetAddr.localAddr;  // print local NetAddress (defaults to: local IP - "127.0.0.1", sclang default port "57120")
NetAddr.langPort;  // print sclang port (default "57120")

thisProcess.openPorts;  // list all open ports



// ------------



n = NetAddr("127.0.0.1", NetAddr.langPort);  // loopback

n.sendMsg("/data", "hello", "bye");  // always define a path as first element of an osc-message --> '/pathName'

n.sendMsg("hello", "bye");  // OSCdef won't listen to this msg (no path specified)


(
OSCdef(\test, { |msg|

	msg.postln;

	// msg[1].postln;

}, '/data', n)
)


// we can add another function to an OSCdef which will be executed upon recieveing an incomming msg

OSCdef(\test).add( { "-- i'm the output of another function --".postln } );


// Functions can't be selectively removed from an OSCdef once added.
// For that we need to clear all active functions from this object's function list.

OSCdef(\test).clear;  // method inherited from --> AbstractResponderFunc


// Our OSCdef won't execute anything upon recieveing messages after clearing.

n.sendMsg("/data", "hello", "bye");



// ------------



// We can use argTemplates to perform further matching operations

(
OSCdef(\argTest, { |msg|

	msg.postln;

}, '/data', n, argTemplate: ['one', 'two'] )
)

// Argument matching works in a "cumulative" way.
// Given the argTemplate --> ['one', 'two']:

n.sendMsg("/data", "one");  // doesn't work

n.sendMsg("/data", "two");  // doesn't work

n.sendMsg("/data", "one", "two");  // works

n.sendMsg("/data", "two", "one");  // doesn't work --> ordering is relevant

n.sendMsg("/data", "one", "two", "three");  // works


// Therefore argTemplates are usful if matching is performed over rigid data-structure where ordering is relevant.



// ------------



// We can add time-stamps to osc messages for scheduling events in the future

(
OSCdef(\timing, { | msg, time |  // the time argument will get the time-stamp + additional latency

	"recieved at: % \nscheduled at: % \ndelta: % \n\n".postf(Main.elapsedTime, time, time - Main.elapsedTime);  // print time difference (with string formating)

	// let's use an event to play the default Synth at the scheduled time:

	fork{

		(time - Main.elapsedTime).wait;  // wait for scheduling with latency compensation

		(
			\freq: msg[1],
			\dur: msg[2]
		).play;
	};

}, '/time')
)

n.sendBundle(1.0, ['/time', 400, 1]);  // use sendBundle to send osc-messages with time-stamps



// ------------



// Let's use SendReply to sample and send data from analysis-UGens over network!

(
SynthDef(\sendAnalysis, { | in = 0, rate = 60 |

	var sndIn, amp, freq, trig;

	// input source
	sndIn = SoundIn.ar(0);  // mic-input (use headphones to prevent feedback!)


	// ----------------------------------------------------------------------
	// use some Analysis UGens to retrieve information about our input signal

	amp = Amplitude.kr(sndIn);  // Amplitue follower

	freq = Pitch.kr(sndIn);  // Pitch detection --> outputs two channels: [0] = detected pitch.
	                         //                                           [1] = boolean if stable pitch was detected.

	// Consider using other feature-detection UGens to retrieve useful
	// information from your input source.
	//
	// Nick Collins's SCMIR-UGens (part of SC3-Plugins) might be worth a try!
	// ----------------------------------------------------------------------


	// use a signal to control the rate at which information is being send over network
	trig = Impulse.kr(rate);

	SendReply.kr(trig, '/analysis', [amp, freq[0], freq[1]])

}).add
)


x = Synth(\sendAnalysis);  // run Synth
x.set(\rate, 10);  // set rate at which information is being send


m = NetAddr("127.0.0.1", 57140);  // specify target NetAddress (OSCjunction)


// Since SendReply only responds to the host we first retrieve messages
// at localhost and the send to our specified target

(
OSCdef(\recvAnalysis, { | msg |

	msg.postln;

	m.sendMsg('/send_data', msg[4]);  // send detected frequency

}, '/analysis', n)
)



/*
// Recieve messages at the target address and use e.g. for ring-modulation

(
SynthDef(\ringMod, { | carrFreq = 400, modFreq = 10 |

	var carr, mod;

	mod = SinOsc.ar(modFreq);
	carr = SinOsc.ar(carrFreq) * mod;

	Out.ar(0, carr * 0.5 !2)

}).add
)

y = Synth(\ringMod);


(
OSCdef(\modRecv, { |msg|

	msg[1].postln;

	y.set(\modFreq, msg[1]);

}, '/send_data')
)
*/
