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
	var env = Env.asr(atk, 1, rel, \sine);
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
	snd = snd * EnvGen.kr(env, gate, doneAction: Done.freeSelf) * amp * 4; // added multiplier for convenience
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
		(minorSeventh / 2) * rrand(0.9999, 1.0001), // voice 5 (Minor seventh)
		(minorSeventh / 2) * rrand(0.9999, 1.0001),
		minorSeventh * rrand(0.999, 1.001),
		minorSeventh * rrand(0.999, 1.001),
		(minorSeventh * 8) * rrand(0.999, 1.001),
		(minorSeventh * 8) * rrand(0.999, 1.001)
	]
],

ffreqs = [ // filter frequencies
	[
		(minorSeventh * 4) * rrand(0.999, 1.001), // voice 5 (minor 7th)
		(minorSeventh * 4) * rrand(0.999, 1.001),
		(minorSeventh * 8) * rrand(0.999, 1.001),
		(minorSeventh * 8) * rrand(0.999, 1.001),
		(minorSeventh * 16) * rrand(0.999, 1.001),
		(minorSeventh * 16) * rrand(0.999, 1.001)
	],
],

// How long to wait until the next chord is played
waitTimes = [0],

// Attack times
attackTimes = [40],

// Sustain times
sustainTimes = [380],

// Release times
releaseTimes = [180],

resEnvs = [ // Resonance envelopes
	[
		Env([0.8, 1.15, 1.0, 0.5], [59, 361, 960]), // voice 1
		Env([0.8, 1.15, 1.0, 0.5], [59, 361, 960]),
		Env([0.8, 1.15, 1.0, 0.5], [59, 361, 960]),
		Env([0.8, 1.15, 1.0, 0.5], [59, 961, 360]),
		Env([0.8, 1.15, 1.0, 0.5], [59, 961, 360]),
		Env([0.8, 1.15, 1.0, 0.5], [59, 961, 360])
	],
	[
		Env([0.0, 1.2, 0.0, 1.3, 0.5], [0.02, 0.02, 1035, 345]), // voice 2 (1380 seconds)
		Env([0.0, 1.2, 0.0, 1.3, 0.5], [0.02, 0.02, 1035, 345]),
		Env([0.0, 1.2, 0.0, 1.3, 0.5], [0.02, 0.02, 690, 690]),
		Env([0.0, 1.2, 0.0, 1.3, 0.5], [0.02, 0.02, 690, 690]),
		Env([0.0, 1.2, 0.0, 1.15, 0.5], [0.02, 0.02, 135, 1245]),
		Env([0.0, 1.2, 0.0, 1.15, 0.5], [0.02, 0.02, 134, 1246]),
	],
	[
		Env([0.0, 1.0, 0.0], [200, 600]), // voice 3
		Env([0.0, 1.0, 0.0], [600, 200]),
		Env([0.0, 1.0, 0.0], [400, 400]),
		Env([0.0, 1.0, 0.0], [400, 400]),
		Env([0.0, 1.3, 0.0], [132, 278]),
		Env([0.0, 1.3, 0.0], [133, 277])
	],
	[
		Env([0.0, 1.15, 0.0], [150, 450]), // voice 4
		Env([0.0, 1.15, 0.0], [450, 150]),
		Env([0.0, 0.5, 0.0], [250, 350]),
		Env([0.0, 0.5, 0.0], [350, 250]),
		Env([0.0, 1.3, 0.0], [100, 310]),
		Env([0.0, 1.3, 0.0], [101, 309])
	],
	[
		Env([0.0, 1.15, 0.0], [150, 450]), // voice 5
		Env([0.0, 1.15, 0.0], [450, 150]),
		Env([0.0, 0.5, 0.0], [250, 350]),
		Env([0.0, 0.5, 0.0], [350, 250]),
		Env([0.0, 1.3, 0.0], [190, 220]),
		Env([0.0, 1.3, 0.0], [190, 220])
	],
	[
		Env([0.0, 1.15, 0.0], [150, 450]), // voice 6
		Env([0.0, 1.15, 0.0], [450, 150]),
		Env([0.0, 0.5, 0.0], [250, 350]),
		Env([0.0, 0.5, 0.0], [350, 250]),
		Env([0.0, 1.3, 0.0], [130, 280]),
		Env([0.0, 1.3, 0.0], [131, 279])
	],
	[
		Env([0.0, 1.15, 0.0], [100, 310]), // voice 7
		Env([0.0, 1.15, 0.0], [310, 100]),
		Env([0.0, 0.5, 0.0], [200, 210]),
		Env([0.0, 0.5, 0.0], [210, 200]),
		Env([0.0, 1.3, 0.0], [130, 280]),
		Env([0.0, 1.3, 0.0], [130, 280])
	],
	[
		Env([0.0, 1.15, 0.0], [105, 405]), // voice 8
		Env([0.0, 1.15, 0.0], [405, 105]),
		Env([0.0, 1.0, 0.0], [255, 255]),
		Env([0.0, 1.0, 0.0], [255, 255]),
		Env([0.0, 1.15, 0.0], [110, 400]),
		Env([0.0, 1.15, 0.0], [400, 110])
	],
	[
		Env([0.0, 1.0, 0.0], [400, 110]), // voice 9
		Env([0.0, 1.0, 0.0], [110, 400]),
		Env([0.0, 1.0, 0.0], [105, 405]),
		Env([0.0, 1.0, 0.0], [405, 105]),
		Env([0.0, 1.0, 0.0], [255, 255]),
		Env([0.0, 1.0, 0.0], [255, 255])
	]
],

// Amplitudes
amplitudes = [
	[0.004],
	[0.1, 0.1, 0.05, 0.05, 0.025, 0.025],
	([0.02, 0.02, 0.025, 0.025, 0.005, 0.005] * 2),
	([0.005, 0.005, 0.005, 0.005, 0.0025, 0.0025] * 2),
	([0.005, 0.005, 0.0025, 0.0025, 0.0025, 0.0025] * 2),
	([0.005, 0.005, 0.005, 0.005, 0.0025, 0.0025] * 2),
	([0.03, 0.03, 0.05, 0.05, 0.002, 0.002] * 2),
	([0.03, 0.03, 0.05, 0.05, 0.005, 0.005] * 2),
	([0.02, 0.02, 0.025, 0.025, 0.005, 0.005])
],

// Pan positions
panPositions = [
	[-1.0, 1.0, -1.0, 1.0, -1.0, 1.0],
	[-1.0, 1.0, -1.0, 1.0, -1.0, 1.0],
	[-1.0, 1.0, -1.0, 1.0, -1.0, 1.0],
	[-1.0, 1.0, -1.0, 1.0, -1.0, 1.0],
	[-1.0, 1.0, -1.0, 1.0, -1.0, 1.0],
	[-1.0, 1.0, -1.0, 1.0, -1.0, 1.0],
	[-1.0, 1.0, -1.0, 1.0, -1.0, 1.0],
	[-1.0, 1.0, -1.0, 1.0, -1.0, 1.0],
	[-1.0, 1.0, -1.0, 1.0, -1.0, 1.0],
];

r = Routine({
	// loop through the frequency chords in our score
	freqs.do({|fs, c|
		var synthGroup = Group(s), // create a group to play our synths on
		ffs = ffreqs.wrapAt(c), // get the ffreqs at the same index as the freqs (wrap if we have more freqs than ffreqs)
		amps = amplitudes.wrapAt(c), // get note amplitudes
		res = resEnvs.wrapAt(c), // get resonance envelopes
		pan = panPositions.wrapAt(c), // get pan positions
		atk = attackTimes.wrapAt(c), // get attack times
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
				\rel, rel // get release times
			], synthGroup); // synthGroup is the target, so each synth will play on the Group we just created
		});
		// sustain and release
		{
			sustainTimes.wrapAt(c).wait; // Sustain synths for the sustain time
			synthGroup.release; // Release synths
		}.fork; // .fork is a shortcut for creating a Routine and playing it immediately.
		waitTimes.wrapAt(c).wait; // Wait to play the next note or chord in the score.
	});
});
)

// Play the routine
r.play