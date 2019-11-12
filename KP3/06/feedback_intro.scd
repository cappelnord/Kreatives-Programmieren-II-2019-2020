(
{
	var duration = 240;
	var feedbackAmp = MouseX.kr(0.5, 3);
	var delayTime = MouseY.kr(64/44100, 0.05);
	var sig = PinkNoise.ar(0.001);
	var env = EnvGen.kr(Env.sine(duration), doneAction: 2);

	var sigFb = FbC({|fb| JPverb.ar(Splay.ar(BPF.ar(fb * feedbackAmp + sig, XLine.ar(20, 2000, duration) * (1..8).scramble, 0.8))).softclip}, 1, delayTime, 2);

	((JPverb.ar(sigFb, 10) * 0.8 + (FbC({|fb| fb * 0.2 + sigFb}, 2/8.0, 2/8.0) * 0.2) + sigFb) * 0.33 * env).tanh;
}.play;
)
