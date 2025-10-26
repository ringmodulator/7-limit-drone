s.boot;

(
SynthDef(
	\drone,
	{
	|
		out = 0,
		freq = 440,
		ffreq = 880,
		amp = 0.1,
		atk = 10,
		sus = 10,
		gate = 1,
		rel = 10,
		pan = 0.0
	|
	var env = Env(levels: [0.00001, 1, 1, 0.00001], times: [atk, sus, rel], curve: [4, \lin, \sine]);
	var snd = LFTri.ar(freq);
	var maxNodes = 16;
	var resEnv = Env(
		Array.fill(maxNodes, 1),
		Array.fill(maxNodes - 1, 1 / maxNodes),
		Array.fill(maxNodes - 1, -4),
		maxNodes - 2,
		nil
	); // Here we set up a default envelope with 16 nodes
	// We need to do this so that the server reserves enough space for us
	// to send it new envelopes.
	var resEnvGen = EnvGen.kr(
		\resInputEnv.kr(resEnv.asArray), // When the synth is running, we can use
		// synthVariable.set(\resInputEnv, someEnv);
		gate
	);
	snd = MoogLadder.ar(in: snd, ffreq: ffreq, res: resEnvGen);
	snd = snd * EnvGen.kr(env, gate, doneAction: Done.freeSelf) * (amp * 8); // added volume multiplier for convenience
	snd = Pan2.ar(snd, pan);
	Out.ar(out, snd);
	}
).add;
)


(
// Calculate note frequencies
var root = 65.41, // Low C
// var root = 73.42, // Low D
// var root = 98, // Low G
minorSecond = root * (15/14),
majorSecond = root * (8/7),
septimalMinorThird = root * (7/6), // tune minor third in logic to this
minorThird = root * (6/5),
majorThird = root * (5/4),
perfectFourth = root * (4/3),
augmentedFourth = root * (7/5), // Logic piano is tuned to this tritone, not 10/7
diminishedFifth = root * (10/7),
perfectFifth = root * (3/2),
minorSixth = root * (8/5),
majorSixth = root * (5/3),
minorSeventh = root * (7/4),
majorSeventh = root * (15/8),

freqs = [ // oscillator frequencies
	[
		(minorSeventh * 16) * rrand(0.999, 1.001), // voice 1 (high minor 7th)
		(minorSeventh * 16) * rrand(0.999, 1.001),
		(minorSeventh * 16) * rrand(0.999, 1.001),
		(minorSeventh * 16) * rrand(0.999, 1.001),
		(minorSeventh * 16) * rrand(0.999, 1.001),
		(minorSeventh * 16) * rrand(0.999, 1.001)
	],
	[
		(root / 2) * rrand(0.9999, 1.0001), // voice 2 (bass root and fifth)
		(root / 2) * rrand(0.9999, 1.0011),
		root * rrand(0.999, 1.001),
		root * rrand(0.999, 1.001),
		perfectFifth * rrand(0.999, 1.001),
		perfectFifth * rrand(0.999, 1.001)
	],
	[
		(perfectFifth / 2) * rrand(0.9999, 1.0001),  // voice 3 (fifth and root)
		(perfectFifth / 2) * rrand(0.9999, 1.0001),
		perfectFifth * rrand(0.999, 1.001),
		perfectFifth * rrand(0.999, 1.001),
		(root * 8) * rrand(0.999, 1.001),
		(root * 8) * rrand(0.999, 1.001)
	],
	[
		(majorSecond) * rrand(0.9999, 1.0001), // voice 4 (major second)
		(majorSecond) * rrand(0.9999, 1.0001),
		(majorSecond * 2) * rrand(0.999, 1.001),
		(majorSecond * 2) * rrand(0.999, 1.001),
		(majorSecond * 8) * rrand(0.999, 1.001),
		(majorSecond * 8) * rrand(0.999, 1.001)
	],
	[
		(minorSeventh / 2) * rrand(0.9999, 1.0001), // voice 5 (Minor seventh)
		(minorSeventh / 2) * rrand(0.9999, 1.0001),
		minorSeventh * rrand(0.999, 1.001),
		(minorSeventh * 2) * rrand(0.999, 1.001),
		(minorSeventh * 4) * rrand(0.999, 1.001),
		(minorSeventh * 4) * rrand(0.999, 1.001)
	],
	[
		(septimalMinorThird) * rrand(0.9999, 1.0001), // voice 6 (septimal minor third)
		(septimalMinorThird) * rrand(0.9999, 1.0001),
		(septimalMinorThird * 2) * rrand(0.999, 1.001),
		(septimalMinorThird * 2) * rrand(0.999, 1.001),
		(septimalMinorThird * 8) * rrand(0.999, 1.001),
		(septimalMinorThird * 8) * rrand(0.999, 1.001)
	],
	[
		(perfectFifth / 2) * rrand(0.9999, 1.0001), // voice 7 (fifth)
		perfectFifth * rrand(0.9099, 1.0001),
		(perfectFifth * 2) * rrand(0.999, 1.001),
		(perfectFifth * 4) * rrand(0.999, 1.001),
		(perfectFifth * 8) * rrand(0.999, 1.001),
		(perfectFifth * 16) * rrand(0.999, 1.001)
	],
	[
		root * rrand(0.999, 1.001), // voice 8 (root)
		root * rrand(0.999, 1.001),
		(root * 4) * rrand(0.999, 1.001),
		(root * 4) * rrand(0.999, 1.001),
		(root * 8) * rrand(0.999, 1.001),
		(root * 8) * rrand(0.999, 1.001)
	],
	[
		septimalMinorThird * rrand(0.999, 1.001), // voice 9 (septimal minor 3rd and 7th)
		minorSeventh * rrand(0.999, 1.001),
		(septimalMinorThird * 4) * rrand(0.999, 1.001),
		(minorSeventh * 4) * rrand(0.999, 1.001),
		(septimalMinorThird * 8) * rrand(0.999, 1.001),
		(minorSeventh * 8) * rrand(0.999, 1.001)
	]
],

ffreqs = [ // filter frequencies
	[
		(minorSeventh * 32) * rrand(0.999, 1.001), // voice 1 (high minor 7th)
		(minorSeventh * 32) * rrand(0.999, 1.001),
		(perfectFifth * 32) * rrand(0.999, 1.001),
		(perfectFifth * 32) * rrand(0.999, 1.001),
		(root * 32) * rrand(0.999, 1.001),
		(root * 32) * rrand(0.999, 1.001)
	],
	[
		(root * 4) * rrand(0.999, 1.001), // voice 2 (root and fifth)
		(root * 4) * rrand(0.999, 1.001),
		(root * 8) * rrand(0.999, 1.001),
		(root * 8) * rrand(0.999, 1.001),
		(perfectFifth * 16) * rrand(0.999, 1.001),
		(perfectFifth * 16) * rrand(0.999, 1.001)
	],
	[
		(perfectFifth * 4) * rrand(0.999, 1.001), // voice 3 (fifth and root)
		(perfectFifth * 4) * rrand(0.999, 1.001),
		(perfectFifth * 8) * rrand(0.999, 1.001),
		(perfectFifth * 8) * rrand(0.999, 1.001),
		(root * 16) * rrand(0.999, 1.001),
		(root * 16) * rrand(0.999, 1.001)
	],
	[
		(majorSecond * 4) * rrand(0.999, 1.001), // voice 4 (major second)
		(majorSecond * 4) * rrand(0.999, 1.001),
		(majorSecond * 8) * rrand(0.999, 1.001),
		(majorSecond * 8) * rrand(0.999, 1.001),
		(majorSecond * 16) * rrand(0.999, 1.001),
		(majorSecond * 16) * rrand(0.999, 1.001)
	],
	[
		(minorSeventh * 4) * rrand(0.999, 1.001), // voice 5 (minor 7th)
		(minorSeventh * 4) * rrand(0.999, 1.001),
		(minorSeventh * 8) * rrand(0.999, 1.001),
		(minorSeventh * 8) * rrand(0.999, 1.001),
		(minorSeventh * 16) * rrand(0.999, 1.001),
		(minorSeventh * 16) * rrand(0.999, 1.001)
	],
	[
		(septimalMinorThird * 4) * rrand(0.999, 1.001), // voice 6 (septimal minor 3rd)
		(septimalMinorThird * 4) * rrand(0.999, 1.001),
		(septimalMinorThird * 8) * rrand(0.999, 1.001),
		(septimalMinorThird * 8) * rrand(0.999, 1.001),
		(septimalMinorThird * 16) * rrand(0.999, 1.001),
		(septimalMinorThird * 16) * rrand(0.999, 1.001)
	],
	[
		(perfectFifth * 4) * rrand(0.999, 1.001), // voice 7 (fifth)
		(perfectFifth * 4) * rrand(0.999, 1.001),
		(perfectFifth * 8) * rrand(0.999, 1.001),
		(perfectFifth * 8) * rrand(0.999, 1.001),
		(perfectFifth * 16) * rrand(0.999, 1.001),
		(perfectFifth * 32) * rrand(0.999, 1.001)
	],
	[
		(root * 8) * rrand(0.999, 1.001), // voice 8 (root)
		(root * 8) * rrand(0.999, 1.001),
		(root * 16) * rrand(0.999, 1.001),
		(root * 16) * rrand(0.999, 1.001),
		(root * 32) * rrand(0.999, 1.001),
		(root * 32) * rrand(0.999, 1.001)
	],
	[
		(septimalMinorThird * 8) * rrand(0.999, 1.001), // voice 9 (minor 3rd and 7th)
		(minorSeventh * 8) * rrand(0.999, 1.001),
		(septimalMinorThird * 4) * rrand(0.999, 1.001),
		(minorSeventh * 4) * rrand(0.999, 1.001),
		(septimalMinorThird * 16) * rrand(0.999, 1.001),
		(minorSeventh * 16) * rrand(0.999, 1.001)
	]
],

// How long to wait until the next chord is played
waitTimes = [60, 120, 120, 90, 180, 120, 180, 180],

// Attack times
attackTimes = [0.01, 0.01, 40, 40, 40, 40, 80, 80, 40],

// Sustain times
sustainTimes = [59.99, 1229.99, 410, 380, 380, 380, 430, 370, 230],

// Release times
releaseTimes = [600, 90, 350, 180, 180, 180, 180, 60, 60],

resEnvs = [ // Resonance envelopes
		[
		Env([0.5, 1.15, 0.5], [62, 598]), // voice 1 (660 seconds)
		Env([0.5, 1.15, 0.5], [62, 598]),
		Env([0.5, 1.15, 0.5], [62, 598]),
		Env([0.5, 1.15, 0.5], [62, 598]),
		Env([0.5, 1.15, 0.5], [62, 598]),
		Env([0.5, 1.15, 0.5], [62, 598])
	],
	[
		Env([0.0, 1.3, 0.5], [975, 345]), // voice 2 (1320 seconds)
		Env([0.0, 1.3, 0.5], [975, 345]),
		Env([0.0, 1.3, 0.5], [660, 660]),
		Env([0.0, 1.3, 0.5], [660, 660]),
		Env([0.0, 1.15, 0.5], [135, 1185]),
		Env([0.0, 1.15, 0.5], [134, 1186]),
	],
	[
		Env([0.0, 1.0, 0.0], [200, 600]), // voice 3 (800 seconds)
		Env([0.0, 1.0, 0.0], [600, 200]),
		Env([0.0, 1.0, 0.0], [400, 400]),
		Env([0.0, 1.0, 0.0], [400, 400]),
		Env([0.0, 1.3, 0.0], [132, 668]),
		Env([0.0, 1.3, 0.0], [133, 667])
	],
	[
		Env([0.0, 1.15, 0.0], [150, 450]), // voice 4 (600 seconds)
		Env([0.0, 1.15, 0.0], [450, 150]),
		Env([0.0, 0.5, 0.0], [250, 350]),
		Env([0.0, 0.5, 0.0], [350, 250]),
		Env([0.0, 1.3, 0.0], [100, 500]),
		Env([0.0, 1.3, 0.0], [101, 499])
	],
	[
		Env([0.0, 1.15, 0.0], [150, 450]), // voice 5 (600 seconds)
		Env([0.0, 1.15, 0.0], [450, 150]),
		Env([0.0, 0.5, 0.0], [250, 350]),
		Env([0.0, 0.5, 0.0], [350, 250]),
		Env([0.0, 1.3, 0.0], [190, 410]),
		Env([0.0, 1.3, 0.0], [190, 410])
	],
	[
		Env([0.0, 1.15, 0.0], [150, 450]), // voice 6 (600 seconds)
		Env([0.0, 1.15, 0.0], [450, 150]),
		Env([0.0, 0.5, 0.0], [250, 350]),
		Env([0.0, 0.5, 0.0], [350, 250]),
		Env([0.0, 1.3, 0.0], [130, 470]),
		Env([0.0, 1.3, 0.0], [131, 469])
	],
	[
		Env([0.0, 1.15, 0.0], [175, 515]), // voice 7 (690 seconds)
		Env([0.0, 1.15, 0.0], [515, 175]),
		Env([0.0, 1.0, 0.0], [350, 340]),
		Env([0.0, 1.0, 0.0], [340, 350]),
		Env([0.0, 1.3, 0.0], [130, 560]),
		Env([0.0, 1.3, 0.0], [130, 560])
	],
	[
		Env([0.0, 1.15, 0.0], [105, 405]), // voice 8 (510 seconds)
		Env([0.0, 1.15, 0.0], [405, 105]),
		Env([0.0, 1.0, 0.0], [255, 255]),
		Env([0.0, 1.0, 0.0], [255, 255]),
		Env([0.0, 1.15, 0.0], [110, 400]),
		Env([0.0, 1.15, 0.0], [400, 110])
	],
	[
		Env([0.0, 1.0, 0.0], [55, 275]), // voice 9 (330 seconds)
		Env([0.0, 1.0, 0.0], [275, 55]),
		Env([0.0, 1.0, 0.0], [170, 160]),
		Env([0.0, 1.0, 0.0], [160, 170]),
		Env([0.0, 1.0, 0.0], [220, 110]),
		Env([0.0, 1.0, 0.0], [110, 220])
	]
],

// Amplitudes
amplitudes = [
	[0.003],
	[0.04, 0.04, 0.04, 0.04, 0.01, 0.01],
	[0.02, 0.02, 0.025, 0.025, 0.005, 0.005],
	[0.02, 0.02, 0.025, 0.025, 0.005, 0.005],
	[0.01, 0.01, 0.005, 0.005, 0.005, 0.005],
	[0.015, 0.015, 0.005, 0.005, 0.005, 0.005],
	[0.01, 0.01, 0.005, 0.005, 0.005, 0.005],
	[0.02, 0.02, 0.025, 0.025, 0.005, 0.005],
	[0.02, 0.02, 0.025, 0.025, 0.005, 0.005]
],

// Pan positions
panPositions = [
	[-1.0, 1.0, -1.0, 1.0, -1.0, 1.0],
	[-1.0, 1.0, -1.0, 1.0, -1.0, 1.0],
	[-1.0, 1.0, -1.0, 1.0, -1.0, 1.0],
	[-1.0, 1.0, -1.0, 1.0, -1.0, 1.0],
	[-1.0, 1.0, -0.25, 0.25, -1.0, 1.0],
	[-1.0, 1.0, -1.0, 1.0, -1.0, 1.0],
	[-1.0, 0.5, -2.5, 2.5, -0.5, 1.0],
	[-1.0, 1.0, -1.0, 1.0, -1.0, 1.0],
	[-1.0, 1.0, -1.0, 1.0, -1.0, 1.0]
];

r = Routine({
	// loop through the frequency chords in our score
	var time = Date.getDate.rawSeconds;
	freqs.do({|fs, c|
		var currentTime = Date.getDate.rawSeconds - time;
		var synthGroup = Group(s), // create a group to play our synths on
		ffs = ffreqs.wrapAt(c), // get the ffreqs at the same index as the freqs (wrap if we have more freqs than ffreqs)
		amps = amplitudes.wrapAt(c), // get note amplitudes
		res = resEnvs.wrapAt(c), // get resonance envelopes
		pan = panPositions.wrapAt(c), // get pan positions
		atk = attackTimes.wrapAt(c), // get attack times
		sus = sustainTimes.wrapAt(c), // get sustain times
		rel = releaseTimes.wrapAt(c), // get release times
		synths = fs.collect({|f, i| // collect all of the frequencies in a given chord. A: Need to understand collect better
			// play a synth for each frequency.
			Synth(\drone, [
				\freq, f,
				\ffreq, ffs.wrapAt(i), // getting individual ffreqs. Use WrapAt here again for arrays of arrays.
				\pan, pan.wrapAt(i), // get pan positions
				\amp, amps.wrapAt(i), // get amplitudes
				\resInputEnv, res.wrapAt(i), // get resonance envelopes
				\atk, atk, // get attack times
				\sus, sus, // get sustain times
				\rel, rel // get release times
			], synthGroup); // synthGroup is the target, so each synth will play on the Group we just created
		});
		("Voice " ++ (c+1) ++ " start: " ++ currentTime.round ++ " seconds").postln;
		waitTimes.wrapAt(c).wait; // Wait to play the next note or chord in the score.
	});
});
)

// Play the routine
r.play