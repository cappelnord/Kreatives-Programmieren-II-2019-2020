/*
Patrick Borgeat, November 2019.


Required extensions (only for the scsynth version)

- SC3plugins
- Feedback Quark

*/


/* === load image and store as array === */


(
var image = Image.open(Document.current.dir ++ "/sparassis-score.png");

var pixels = image.pixels;
var array = Array.newClear(pixels.size);

// uses bitshifting to extract color channels from integers representing the color
// calculates the average of the 3 color channels and stores it as a normalized float

pixels.do {|c, i|
	var blue = c &  0x000000FF;
	var green = c & 0x0000FF00 >> 8;
	var red = c & 0x00FF0000 >> 16;
	var value = red + green + blue / 3.0 / 256.0;
	array[i] = value;
};

i = (array: array, width: image.width, height: image.height);
);


/* === use MIDI output === */


(
// https://github.com/cappelnord/Kreatives-Programmieren-II-2019-2020/blob/master/KP3/03/task_01_template.scd

c = {|destination, channel=0, retrigger=true|
	var table = Array.fill(128, nil);

	{|num, vel=64, dur=1|

		var routine = table[num];
		routine.isNil.if ({
			destination.noteOn(channel, num, vel);
		}, {
			routine.stop;
			retrigger.if {
				destination.noteOff(channel, num, 64);
				destination.noteOn(channel, num, vel);
			};
		});

		table[num] = {
			dur.wait;
			destination.noteOff(channel, num, 64);
			table[num] = nil;
		}.fork(clock: TempoClock.default);
		dur;
	};
};
)


MIDIClient.init;
MIDIClient.destinations

// configure your MIDI output device here

m = MIDIOut.newByName("Microsoft GS Wavetable Synth", "Microsoft GS Wavetable Synth");
// m = MIDIOut.newByName("Yamaha USB-MIDI-1", "Yamaha USB-MIDI-1");


(
// midi panic on strg./cmd.
// https://github.com/cappelnord/Kreatives-Programmieren-II-2019-2020/blob/master/FAQ/midi_panic-button.scd
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


/* === synthesis with scsynth === */

(
// FM synth with some random detunings and slight amplitude modulation to the end

SynthDef(\fmPling, {|freq=440, out=0, pan=0, amp=0.1, len=8, modIndex=5, attack=0.001|
	var randomizedFreq = freq * Rand(0.995, 1.005);
	var mod = SinOsc.ar(freq*4.45 + Rand(0, 0.1)) * XLine.ar(freq * modIndex, 0.001, 0.1);
	var mod2 = SinOsc.ar(randomizedFreq*2) * XLine.ar(freq * 0.4, 0.001, 5);
	var sig = SinOsc.ar(randomizedFreq + mod + mod2, phase: 0.5pi) * AmpCompA.kr(randomizedFreq, (21+12).midicps);
	var ampModEnv = EnvGen.kr(Env([0, 0, 0.7], [1, len]));
	var ampMod = (1.0 - ampModEnv) + (SinOsc.ar(Rand(0.1, 0.8)) * ampModEnv);
	var env = EnvGen.ar(Env.perc(attack, len, 1, -2), doneAction: 2);
	Out.ar(out, Pan2.ar(sig * env * amp * ampMod, pan));
}).add;

// effects: filtered feedback delays and reverb
SynthDef(\fmPlingFX, {|in=0, out=0|
	var sig = In.ar(in, 2);
	var sigToDelay = HPF.ar(sig, 300);
	sig = sig + (FbC({|fb| LPF.ar(sigToDelay + (fb * 0.4), 3000)}, 4/8.0, 4/8.0, 2) * 0.2) + (FbC({|fb|
		LPF.ar(HPF.ar(sigToDelay + (fb * 0.8), 2000), 6000)
	}, 6/8.0, 6/8.0, 2) * 0.1);
	sig = sig + (JPverb.ar(sig, 16, 0.2) * 0.09);
	Out.ar(out, sig * 18.dbamp); // push gain up a bit
}).add;

e = {
	var bus = Bus.audio(s, 2);
	var fxNode = Synth(\fmPlingFX, [\in, bus, \out, 0]);
	var times = 0!128;
	// sounds should not be retriggered too quick in succession
	var thresh = 0.125;

	{|num, vel=64, dur=1|
		((times[num] + thresh) <= TempoClock.default.beats).if({

			// parameters are adjusted to velocity and pitch ..
			// .. this matches personal preferences!

			Synth(\fmPling, [
				\freq, num.midicps,
				\amp, vel.linexp(0, 128, -60.dbamp, 1) * num.linexp(50, 128, 1, -18.dbamp) * num.linexp(0, 60, -18.dbamp, 1),
				\pan, num.linlin(20, 90, 0, 0.6) * (num*0.2).sin,
				\len, dur,
				\modIndex, vel.linlin(0, 128, 2, 6),
				\attack, num.linexp(0, 128, 0.002, 0.0005) * 3,
				\out, bus
			]);
			times[num] = TempoClock.default.beats;
		});
	}
}
)

/* === the main code (look further down for configuration options) === */


(
// notes that can be used and functions to convert y <=> pitch

var notes = ((21+12)..(108-12));

var noteForY = {|y|
	notes[(y * notes.size).floor];
};

var yForNote = {|note|
	(note - notes[0]) / notes.size.asFloat;
};


// this returns a function that sees if a pitch matches a scale, either returning
// a probability of 1.0 or 0.0. This can be used to filter out pitches

var scaleFilter = {|scale, root=0|
	var stepsPerOctave;
	var degrees;

	(scale.class == Scale).if ({
		stepsPerOctave = scale.stepsPerOctave;
		degrees = scale.degrees + root % stepsPerOctave;
	}, {
		stepsPerOctave = 12;
		degrees = scale;
	});

	{|x, y|
		var note = noteForY.value(y) % stepsPerOctave;
		degrees.indexOf(note).isNil.not.if(1.0, 0.0);
	};
};


// fundamental Freq

var fundamentalFreqFunction = {|x|
	x.linexp(0, 1, 27.5, 27.5 * 4);
};

var fundamentalFreqSections = [0.25, 1, 8];

var closestFreqRatioProbability = {|x, y|
	var freq = noteForY.value(y).midicps;
	var fund = fundamentalFreqFunction.value(x);
	var targets = fundamentalFreqSections * fund;
	var harmonics;
	var deviation;

	// look in which section we are and set as fundamental frequency
	targets.do {|target|
		(freq >= target).if {
			fund = target;
		};
	};

	harmonics = (1..8) * fund;
	deviation = harmonics.collect({|h| (h-freq).abs / h}).sort.first;

	// shaping the final probability (according to my likings)
	(1.0 - deviation.sqrt.sqrt - 0.2).max(0) * (1.0/0.8);
};


// this samples the image and returns a probability

var sampleImageProbability = {|x, y|
	var ret;
	x = (x * i[\width]).floor;
	y = (y * i[\height]).floor;
	ret = i[\array][y * i.width + x];
	// shaping the final probability with sqrt (according to my likings)
	(1.0 - ret.sqrt.sqrt.sqrt);
};


// the main Monte Carlo loop

var doMonteCarlo = {|xFunc, yFunc, playProbabilityFunc, retryProbabilityFunc=0.5, maxRetries=64|
	var redrawProbability;
	var playProbability;

	var retry = true;
	var ret = false;
	var numRetries = 0;

	{retry && (ret == false) && (numRetries < maxRetries)}.while({

		var x = xFunc.value();
		var y = yFunc.value();

		var playProbability = playProbabilityFunc.value(x, y);
		var retryProbability = retryProbabilityFunc.value(x, y);

		playProbability.coin.if({
			ret = (x: x, y: y, probability: playProbability);
		}, {
			retry = retryProbability.coin;
			numRetries = numRetries + 1;
			(numRetries == maxRetries).if ({
				"Reached maximum number of retries!".postln;
			});
		});
	});

	ret;
};


/* === configure things === */


// main probability function
var playProbabilityFunc = sampleImageProbability * closestFreqRatioProbability * scaleFilter.value(Scale.minorPentatonic);

// this could also be a function(x, y)
var retryProbabilityFunc = 0.55;

var playFunction = c.value(m, 0, true);  // this is for MIDI
// var playFunction = e.value(); // this is for FM Synthesis

// total length in beats (can change tempo with TempoClock)
var length = 30*60;

// duration pattern
var durPattern = Prand([0.125, 0.125, 0.25, 0.5, 1, 2, 4], inf);

// how many paralell processes should run
var numRoutines = 64;

// safeguard in case we reach a point where success is impossible/very unlikely
var maxRetries = 100;

// alternative: \visualize for visualizing probabilites
var mode = \play;


/* === end configuration === */



// some post-preparation code
playProbabilityFunc = playProbabilityFunc.min(1).max(0);
retryProbabilityFunc = retryProbabilityFunc.min(1).max(0);

(mode == \play).if({
	numRoutines.do {|i|
		// main play loop
		Routine({
			var durStream = durPattern.asStream;
			var startTime = TempoClock.default.beats;
			var x = 0;

			// displaces them a bit
			(i * (1.0/16.0)).wait;

			{x < 1.0}.while({
				var ret;
				// advance x in time
				x = TempoClock.default.beats.linlin(startTime, startTime + length, 0, 1);
				ret = doMonteCarlo.value(x, {1.0.rand}, playProbabilityFunc, retryProbabilityFunc, maxRetries);

				(ret != false).if({

					// note, velocity and durations are calculated here
					var note = noteForY.value(ret[\y]);
					var vel = 48 + ((ret[\x] * (i*0.1)).sin * 6) + 0.gauss(8).abs + (6 * ret[\probability]);
					var dur = 10; // 10 is nice for piano, too much for the FM synths

					playFunction.value(note, vel, dur);
				});

				durStream.next.wait;
			});
		}).play;
	}
});



(mode == \visualize).if({
	// window size of viszalization
	var w = 1920;
	var h = 1080;
	var window = Window("Probability Distribution per Note", Rect(300, 300, w, h), false);

	// see help file for Pen
	window.drawFunc = {
		var noteHeight = h.asFloat / notes.size;

		// guess max probability for normalizing (this is a bit dumb)
		var max = 0.0;
		var min = 1.0;
		10000.do {
			var value = playProbabilityFunc.value(1.0.rand, 1.0.rand);
			(value > max).if {max = value;};
			(value < min).if {min = value;};
		};
		("max: " ++ max).postln;
		("min: " ++ min).postln;


		Pen.width = 1;
		Pen.smoothing = false;

		// let's move from x to y
		w.do {|px|
			var x = px / w.asFloat;

			// calc probabilities on all y
			var bins = ();
			(0, 0.001..1).do {|y|
				var probability = playProbabilityFunc.value(x, y);
				var note = noteForY.value(y);
				bins[note].isNil.if {bins[note] = List()};
				bins[note].add(probability);
		    };

			// calculate the mean values
			bins = bins.collect({|list| list.mean});

			// draw a line; note for note!
			bins.keys.do {|note|
				var py = h - (yForNote.value(note) * h);
				var grey = (bins[note] / max).min(1).sqrt;
				// grey.postln;
				Pen.strokeColor = Color.grey(grey);
				Pen.line(Point(px, py), Point(px, py - noteHeight));
				Pen.stroke;
			};
		};
		"done".postln;
	};
	window.refresh;
	window.front;
});
)
