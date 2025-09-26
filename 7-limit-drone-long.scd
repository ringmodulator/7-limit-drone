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
	snd = snd * EnvGen.kr(env, gate, doneAction: Done.freeSelf) * amp;
	snd = Pan2.ar(snd, pan);
	Out.ar(out, snd);
	}
).add;
)


(
// Calculate note frequencies
var root = 65.41, // Low C
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
octave = root * 2,

freqs = [ // oscillator frequencies
	[
		(minorSeventh * 16) * rrand(0.999, 1.001), // voice 1 (high minor 7th) - this should be quiet and silvery
		(minorSeventh * 16) * rrand(0.999, 1.001),
		(minorSeventh * 16) * rrand(0.999, 1.001),
		(minorSeventh * 16) * rrand(0.999, 1.001)
	],
	[
		(root / 2) * rrand(0.999, 1.001), // voice 2 (bass root)
		(root / 2) * rrand(0.999, 1.001),
		root * rrand(0.999, 1.001),
		root * rrand(0.999, 1.001)
	],
	[
		(perfectFifth / 2) * rrand(0.999, 1.001),  // voice 3 (fifth)
		(perfectFifth / 2) * rrand(0.999, 1.001),
		perfectFifth * rrand(0.999, 1.001),
		perfectFifth * rrand(0.999, 1.001),
		(perfectFifth * 8) * rrand(0.999, 1.001),
		(perfectFifth * 8) * rrand(0.999, 1.001)
	],
	[
		(septimalMinorThird / 2) * rrand(0.999, 1.001), // voice 4 (septimal minor 3rd)
		(septimalMinorThird / 2) * rrand(0.999, 1.001),
		septimalMinorThird * rrand(0.999, 1.001),
		septimalMinorThird * rrand(0.999, 1.001),
		(septimalMinorThird * 8) * rrand(0.999, 1.001),
		(septimalMinorThird * 8) * rrand(0.999, 1.001)
	],
	[
		(augmentedFourth / 2) * rrand(0.999, 1.001), // voice 5 (tritone)
		(augmentedFourth / 2) * rrand(0.999, 1.001),
		augmentedFourth * rrand(0.999, 1.001),
		augmentedFourth * rrand(0.999, 1.001),
		(augmentedFourth * 8) * rrand(0.999, 1.001),
		(augmentedFourth * 8) * rrand(0.999, 1.001)
	],
	[
		(perfectFifth / 2) * rrand(0.999, 1.001), // voice 6 (fifth and minor seventh)
		(minorSeventh / 2) * rrand(0.999, 1.001),
		minorSeventh * rrand(0.999, 1.001),
		perfectFifth * rrand(0.999, 1.001),
		(perfectFifth * 8) * rrand(0.999, 1.001),
		(minorSeventh * 8) * rrand(0.999, 1.001)
	]
],

ffreqs = [ // filter frequencies
	[
		(minorSeventh * 32) * rrand(0.999, 1.001), // voice 1 (high minor 7th)
		(minorSeventh * 32) * rrand(0.999, 1.001),
		(root * 32) * rrand(0.999, 1.001),
		(root * 32) * rrand(0.999, 1.001)
	],
	[
		octave * rrand(0.999, 1.001), // voice 2 (bass root)
		octave * rrand(0.999, 1.001),
		(octave * 2) * rrand(0.999, 1.001),
		(octave * 2) * rrand(0.999, 1.001)
	],
	[
		(perfectFifth * 16) * rrand(0.999, 1.001), // voice 3 (fifth)
		(perfectFifth * 16) * rrand(0.999, 1.001),
		(perfectFifth * 4) * rrand(0.999, 1.001),
		(perfectFifth * 4) * rrand(0.999, 1.001),
		(septimalMinorThird * 16) * rrand(0.999, 1.001),
		(septimalMinorThird * 16) * rrand(0.999, 1.001)
	],
	[
		(septimalMinorThird * 8) * rrand(0.999, 1.001), // voice 4 (septimal minor 3rd)
		(septimalMinorThird * 16) * rrand(0.999, 1.001),
		(septimalMinorThird * 4) * rrand(0.999, 1.001),
		(septimalMinorThird * 4) * rrand(0.999, 1.001),
		(septimalMinorThird * 8) * rrand(0.999, 1.001),
		(septimalMinorThird * 16) * rrand(0.999, 1.001)
	],
	[
		(augmentedFourth * 8) * rrand(0.999, 1.001), // voice 5 (tritone)
		(augmentedFourth * 16) * rrand(0.999, 1.001),
		(augmentedFourth * 4) * rrand(0.999, 1.001),
		(augmentedFourth * 4) * rrand(0.999, 1.001),
		(augmentedFourth * 8) * rrand(0.999, 1.001),
		(augmentedFourth * 16) * rrand(0.999, 1.001)
	],
	[
		(perfectFifth * 8) * rrand(0.999, 1.001), // voice 6 (fifth and minor seventh)
		(minorSeventh * 8) * rrand(0.999, 1.001),
		(minorSeventh * 4) * rrand(0.999, 1.001),
		(perfectFifth * 4) * rrand(0.999, 1.001),
		(perfectFifth * 16) * rrand(0.999, 1.001),
		(minorSeventh * 16) * rrand(0.999, 1.001)
	]
],

// How long to wait until the next chord is played
waitTimes = [180, 195, 195, 195, 195],

// Attack times
attackTimes = [0.01, 180, 180, 180, 180, 180],

// Sustain times
sustainTimes = [360, 1440, 540, 540, 540, 540],

// Release times
releaseTimes = [900, 180, 180, 180, 180, 180],

resEnvs = [ // Resonance envelopes
	[
		Env([0.8, 1.3, 1.0, 0.5], [180, 360, 720]), // voice 1 (high minor 7th)
		Env([0.8, 1.3, 1.0, 0.5], [180, 360, 720]),
		Env([0.8, 1.3, 1.0, 0.5], [360, 180, 720]),
		Env([0.8, 1.3, 1.0, 0.5], [360, 180, 720])
	],
	[
		Env([0.5, 1.1, 0.5], [600, 1260]), // voice 2 (bass root)
		Env([0.5, 1.1, 0.5], [900, 960]),
		Env([0.5, 1.1, 0.5], [1200, 660]),
		Env([0.5, 1.1, 0.5], [1500, 360])
	],
	[
		Env([0.0, 1.1, 0.0], [120, 720]), // voice 3 (fifth)
		Env([0.0, 1.1, 0.0], [360, 540]),
		Env([0.0, 0.5, 0.0], [450, 450]),
		Env([0.0, 0.5, 0.0], [450, 450]),
		Env([0.0, 1.0, 0.0], [540, 360]),
		Env([0.0, 1.0, 0.0], [720, 180])
	],
	[
		Env([0.0, 1.1, 0.0], [120, 720]), // voice 4 (septimal minor 3rd)
		Env([0.0, 1.1, 0.0], [360, 540]),
		Env([0.0, 1.1, 0.0], [450, 450]),
		Env([0.0, 1.1, 0.0], [450, 450]),
		Env([0.0, 1.1, 0.0], [540, 360]),
		Env([0.0, 1.1, 0.0], [720, 180])
	],
	[
		Env([0.0, 1.1, 0.0], [120, 720]), // voice 5 (tritone)
		Env([0.0, 1.1, 0.0], [360, 540]),
		Env([0.0, 1.1, 0.0], [450, 450]),
		Env([0.0, 1.1, 0.0], [450, 450]),
		Env([0.0, 1.1, 0.0], [540, 360]),
		Env([0.0, 1.1, 0.0], [720, 180])
	],
	[
		Env([0.0, 1.1, 0.5], [120, 720]), // voice 6 (fifth and minor seventh)
		Env([0.0, 1.1, 0.5], [360, 540]),
		Env([0.0, 1.1, 0.5], [450, 450]),
		Env([0.0, 1.1, 0.5], [450, 450]),
		Env([0.0, 1.1, 0.5], [540, 360]),
		Env([0.0, 1.1, 0.5], [720, 180])
	]
],

// Amplitudes
amplitudes = [
	[0.008, 0.008, 0.008, 0.008],
	[0.3, 0.3, 0.2, 0.2],
	[0.2, 0.2, 0.02, 0.02, 0.01, 0.01],
	[0.05, 0.05, 0.2, 0.2, 0.02, 0.02],
	[0.05, 0.05, 0.2, 0.2, 0.02, 0.02],
	[0.05, 0.05, 0.2, 0.2, 0.02, 0.02]
],

// Pan positions
panPositions = [
	[-1.0, 1.0, -1.0, 1.0],
	[-1.0, 1.0, -1.0, 1.0],
	[-1.0, 1.0, -0.5, 0.5, -1.0, 1.0],
	[-1.0, 1.0, -0.5, 0.5, -1.0, 1.0],
	[-1.0, 1.0, -0.5, 0.5, -1.0, 1.0],
	[-1.0, 1.0, -0.5, 0.5, -1.0, 1.0]
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