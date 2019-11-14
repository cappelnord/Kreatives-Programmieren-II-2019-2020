(
{
	var duration = 120;
	var feedbackAmp = MouseX.kr(0.25, 3, 1).poll;
	var delayTime = MouseY.kr(64/44100, 0.05, 1, 0.5);
	var env = EnvGen.kr(Env.sine(duration), doneAction: 2);
	var fFreqs = XLine.ar(50, 1000, duration) * (1..8).scramble * {LFNoise2.kr(0.2.rand).range(0.98, 1.02)}!4;

	var sig = PinkNoise.ar(0.001);

	var sigFb = FbC({|fb| JPverb.ar(Splay.ar(BPF.ar(fb * feedbackAmp + sig, fFreqs, 0.7))).softclip}, 1, delayTime, 2);

	((JPverb.ar(sigFb, 5) * 0.8 + (FbC({|fb| fb * 0.2 + sigFb}, 2/8.0, 2/8.0) * 0.2) + sigFb) * 0.33 * env).tanh;
}.play;
)
