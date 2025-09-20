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
minorThird = root * (6/5),
majorThird = root * (5/4),
perfectFourth = root * (4/3),
augmentedFourth = root * (7/5),
diminishedFifth = root * (10/7),
perfectFifth = root * (3/2),
minorSixth = root * (8/5),
majorSixth = root * (5/3),
minorSeventh = root * (7/4),
majorSeventh = root * (15/8),
octave = root * 2,

freqs = [ // oscillator frequencies
	[
		minorSeventh * 8, // voice 1 (high minor 7th)
		(minorSeventh * 8) + 4,
		minorSeventh * 16,
		(minorSeventh * 16) + 8
	],

	[
		root, // voice 2 (bass root)
		root + 3,
		(root / 2),
		(root/2) + 4

	],

	[
		perfectFifth,  // voice 3 (fifth)
		perfectFifth + 1

	],

	[
		minorThird, // voice 4 (minor 3rd)
		minorThird + 0.5

	],

	[
		perfectFourth, // voice 5 (fourth)
		perfectFourth + 2
	],
],

ffreqs = [ // filter frequencies
	[
		(minorSeventh * 16) + 4, // voice 1 (high minor 7th)
		minorSeventh * 16,
		minorSeventh * 32,
		(minorSeventh * 32) + 8
	],

	[
		octave * 2, // voice 2 (bass root)
		(octave * 2) + 2,
		octave,
		octave + 4
	],

	[
		perfectFifth * 4, // voice 3 (fifth)
		perfectFifth * 8
	],

	[
		minorThird * 8, // voice 4 (minor 3rd)
		minorThird * 4
	],

	[
		perfectFourth * 4, // voice 5 (fourth)
		perfectFourth * 8
	],
],

// How long to wait until the next chord is played
waitTimes = [60, 100, 100, 100],

// Attack times
attackTimes = [0.01, 20, 60, 60, 60],

// Sustain times
sustainTimes = [120, 500, 180, 180, 180],

// Release times
releaseTimes = [300, 20, 60, 60, 60],

resEnvs = [ // Resonance envelopes
	[
		Env([0.8, 1.3, 0.9, 0.0], [60, 60, 300]), // voice 1 (high minor 7th)
		Env([0.8, 1.3, 0.9, 0.0], [60, 60, 300]),
		Env([0.0, 0.8, 0.5, 0.0], [60, 120, 240]),
		Env([0.0, 0.8, 0.5, 0.0], [60, 120, 240])],

	[
		Env([0.0, 1.3, 1.0], [500, 120]), // voice 2 (bass root)
		Env([0.0, 1.4, 1.0], [500, 120]),
		Env([0.0, 1.1, 1.0], [500, 120]),
		Env([0.0, 1.1, 1.0], [500, 120])
	],

	[
		Env([0.0, 1.0, 0.5], [150, 150]) // voice 3 (fifth)
	],

	[
		Env([0.0, 1.3, 0.5], [150, 150]) // voice 4 (minor 3rd)
	],

	[
		Env([0.5, 1.0, 0.0], [150, 150]) // voice 5 (fourth)
	],
],

// Amplitudes
amplitudes = [
	[0.3, 0.3, 0.1, 0.1],
	[0.5, 0.5, 0.2, 0.2],
	[0.5, 0.5],
	[0.5, 0.5],
	[0.5, 0.5]
],

// Pan positions
panPositions = [
	[-1.0, 1.0, -0.5, 0.5],
	[-1.0, 1.0, -0.5, 0.5],
	[-0.5, 0.5],
	[-0.5, 0.5],
	[0.5, 0.5]
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