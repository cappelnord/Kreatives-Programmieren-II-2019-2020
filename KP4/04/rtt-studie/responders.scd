NetAddr.langPort;

/*
OSCjunction Setup:
- Node 2 auswählen
- Eigenen langPort herausfinden
- 'Start Receiving' auf 'RTT-Studie-Broadcast' (Port wie bei NetAddr.langPort)
- 'Start Sending' auf 'RTT-Studie-Rückkanal' (Port: 57140)
*/

(
var net = NetAddr("127.0.0.1", 57140);
var id = 500000000.rand;

var groupChangeProbability = 0.2;
var numGroups = 1;
var group = 0;

("My ID:" + id).postln;

OSCdef(\call, {|msg|
	// Incoming OSC message layout:
	// [s: cmd, i: group, i: callID, i: numGroups]
	msg.postln;

	numGroups = msg[3];

	(group.isNil || groupChangeProbability.coin || (group >= numGroups)).if {
		group = numGroups.rand.value;
		("Now in group " + group).postln;
	};

	(msg[1] == group).if ({
		// send back
		net.sendMsg('/response', id, msg[2]);
		"Responded!".postln;
	}, {
		"Got a call, but not for my group.".postln;
	});

}, '/call');
)
