(
SynthDef(\fltSaw, {|freq=440, ffreq=880, out=0, amp=0.1, gate=1|
	var sig = Mix.ar(Saw.ar(Lag2.kr(freq, 0.3) * [1, 1.01, 0.5]));
	var env = EnvGen.ar(Env.asr(0.2, 1, 0.5), gate, doneAction: 2);
	sig = RLPF.ar(sig, Lag2.kr(ffreq, 0.3), 0.7);
	Out.ar(out, (sig * env * amp).dup);
}).add;
)

(
// the code assumes that cursors and objects will not have
// the same session id and that only 1 TUIO supplier is connected

// does not get called on first set
var onUpdate = {|obj|
	obj[\node].set(\freq, obj[\y].linexp(0, 1, 880, 55));
	obj[\node].set(\ffreq, obj[\x].linexp(0, 1, 110, 4400));
};

// gets called after the first set
var onBorn = {|obj|
	obj[\node] = Synth(\fltSaw, [
		\freq, obj[\y].linexp(0, 1, 880, 55),
		\ffreq, obj[\x].linexp(0, 1, 110, 4400)
	]);
};

// gets called before the object gets deleted
var onDeath = {|obj|
	obj[\node].set(\gate, 0); // free ?
};


// ===
// here starts the boring code

var entities = ();

// see: https://www.tuio.org/?specification

var typeMap = (
	'/tuio/2Dcur': 'cur',
	'/tuio/2Dobj': 'obj'
);

var keysMap = (
	'cur': [\x, \y, \dx, \dy, \m],
	'obj': [\id, \x, \y, \a, \dx, \dy, \da, \m, \r]
);

var spawnEntity = {|type, s_id|
	(
		type: type,
		initialized: false,
		s_id: s_id,
	);
};

var oscResponderFunc = {|msg|
	var type = typeMap[msg[0]];

	(msg[1] === 'alive').if {
		// all s_ids (session IDs)
		var s_ids = msg[2..];

		s_ids.do {|s_id|
			// spawn a new object if not yet stored
			entities[s_id].isNil.if {
				entities[s_id] = spawnEntity.value(type, s_id);
			};
		};

		// test for objects not alive
		entities.keys.do {|s_id|
			var entity = entities[s_id];
			// only process objects of matching type
			(entity[\type] === type).if {
				s_ids.includes(s_id).not.if {
					// entity does not seem to be alive anymore
					onDeath.value(entity);
					entities[s_id] = nil;
				};
			};
		};
	};

	(msg[1] === 'set').if {
		var s_id = msg[2];
		var values = msg[3..];

		// we should be able to assume that entity is not nil ...
		var entity = entities[s_id];

		// use the keyMap to assign values
		keysMap[entity[\type]].do {|key, i|
			entity[key] = values[i];
		};

		entity[\initialized].if({
			onUpdate.value(entity);
		}, {
			onBorn.value(entity);
			entity[\initialized] = true;
		});
	};
};

OSCdef('2Dcur', oscResponderFunc, '/tuio/2Dcur');
OSCdef('2Dobj', oscResponderFunc, '/tuio/2Dobj');

o = entities;
)