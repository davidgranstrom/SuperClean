
// these are the global effects on each orbit
~clean.orbits.do { |x| x.globalEffects.postln }

// say you want to add a global low pass filter on the first orbit

// first you generate the synth defs for it
(
var numChannels = ~clean.numChannels;
(1..SuperClean.maxSampleNumChannels).do { |numChannels|
	SynthDef("clean_global_lpf" ++ numChannels, { |dryBus, effectBus, gate = 1, dry = 0|
		var ffreq, rq;
		var signal = In.ar(dryBus, numChannels);
		signal = signal.asArray.collect { |sig|
			ffreq = LFNoise2.kr(0.1).exprange(60, 13000);
			rq = 1/LFNoise2.kr(0.1).exprange(10, 20);
			RLPF.ar(sig, ffreq, rq).tanh;
		};
		signal = signal * EnvGen.kr(Env.asr, gate, doneAction:2);
		CleanPause.ar(signal.sum, graceTime:4);
		XOut.ar(effectBus, 1 - dry, signal)
	}).add;
};
)


// then add the effect to the orbit
(
~clean.orbits.do { |x|
	x.globalEffects = ~clean.orbits[0].globalEffects.addFirst(
		GlobalCleanEffect(\clean_global_lpf, [\dry])
	)
};
~clean.orbits[0].initNodeTree;
)

~clean.orbits.do { |x| x.globalEffects.postln; " ----------".postln; }

// then play some tidal pattern ...
// in tidal

cps (40/120)

d1 $ sound "[sn [sn sn]][sn [sn sn*3]][sn [sn*5 sn]][bd bd]" # dry "0.4" # orbit "0 1"

// for proper use, better replace "dry" with a specific name and add that to tidal, e.g. "lpfdry" or whatever.