




// modulated band limited impulse
(
SynthDef(\impin, { |out, freq = 440, pan|
	var sound;
	sound = \input.ar(0 ! ~clean.numChannels);
	sound = sound * LFSaw.ar(freq).max(0);
	OffsetOut.ar(out,
		CleanPan.ar(sound, ~clean.numChannels, pan)
	)
}).add
);


SuperClean.default = ~clean;

(
Pdef(\x,
	Ppar([
		Pbind(
			\type, \clean,
			\s, \cr,
			\to, 0,
			\psst, 1,
			\pan, Pseq([0, 1], inf)
		),
		Pbind(
			\type, \clean,
			\s, \impin,
			\from, 0,
			\toArg, \input,
			\freq, Pseq([2, Prand([3, 7], 1), 153, 78], inf)
		)
	])
).stop.play
)


(
(type: \clean, s: \cr, pan: 1.0.rand2, speed: 0.8, to: 0, psst:1).play;
(type: \clean, s: \impin, from: 0, toArg: \input, freq: exprand(3, 1000.0)).play;
)

