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
		(root / 2),
		(root / 2),
		(septimalMinorThird * 2),
		(septimalMinorThird * 2),
		perfectFifth,
		perfectFifth,
		(minorSeventh * 2),
		(minorSeventh * 2)
	],
	[
		(septimalMinorThird / 2),
		(septimalMinorThird / 2),
		(perfectFifth * 2),
		(perfectFifth * 2),
		minorSeventh,
		minorSeventh,
		(root * 2),
		(root * 2),
	],
	[
		(perfectFifth / 2),
		(perfectFifth / 2),
		(minorSeventh * 2),
		(minorSeventh * 2),
		root,
		root,
		(septimalMinorThird * 2),
		(septimalMinorThird * 2),
	],
	[
		(minorSeventh / 2),
		(minorSeventh / 2),
		(root * 2),
		(root * 2),
		septimalMinorThird,
		septimalMinorThird,
		(perfectFifth * 2),
		(perfectFifth * 2),
	],
	[
		(root / 2),
		(root),
		(septimalMinorThird * 2),
		(septimalMinorThird * 2),
		perfectFifth,
		perfectFifth,
		(minorSeventh * 2),
		(minorSeventh * 2)
	],
],

ffreqs = [ // filter frequencies
	[
		(root * 2),
		(root * 2),
		(septimalMinorThird * 4),
		(septimalMinorThird * 4),
		(perfectFifth * 8),
		(perfectFifth * 8),
		(minorSeventh * 16),
		(minorSeventh * 16)
	],
	[
		(septimalMinorThird * 2),
		(septimalMinorThird * 2),
		(perfectFifth * 4),
		(perfectFifth * 4),
		(minorSeventh * 8),
		(minorSeventh * 8),
		(root * 16),
		(root * 16)
	],
	[
		(perfectFifth * 2),
		(perfectFifth * 2),
		(minorSeventh * 4),
		(minorSeventh* 4),
		(root * 8),
		(root * 8),
		(septimalMinorThird * 16),
		(septimalMinorThird * 16)
	],
	[
		(minorSeventh * 2),
		(minorSeventh * 2),
		(root * 4),
		(root * 4),
		(septimalMinorThird * 8),
		(septimalMinorThird * 8),
		(perfectFifth * 16),
		(perfectFifth* 16)
	],
	[
		(root * 2),
		(root * 2),
		(septimalMinorThird * 4),
		(septimalMinorThird * 4),
		(perfectFifth * 8),
		(perfectFifth * 8),
		(minorSeventh * 16),
		(minorSeventh * 16)
	]
],

// How long to wait until the next chord is played
waitTimes = [150, 150, 150, 150],

// Attack times
attackTimes = [60, 60, 60, 60, 60],

// Sustain times
sustainTimes = [780, 780, 780, 780, 780],

// Release times
releaseTimes = [60, 60, 60, 60, 60],

resEnvs = [ // Resonance envelopes
	[
		Env([0.0, 0.0, 0.0], [112.5, 787.5]),
		Env([0.0, 0.0, 0.0], [225, 675]),
		Env([0.0, 0.0, 0.0], [337.5, 562.5]),
		Env([0.0, 0.0, 0.0], [450, 450]),
		Env([0.0, 0.0, 0.0], [450, 450]),
		Env([0.0, 0.0, 0.0], [562.5, 337.5]),
		Env([0.0, 0.0, 0.0], [675, 225]),
		Env([0.0, 0.0, 0.0], [787.5, 112.5])
	],
	[
		Env([0.0, 0.0, 0.0], [112.5, 787.5]),
		Env([0.0, 0.0, 0.0], [225, 675]),
		Env([0.0, 0.0, 0.0], [337.5, 562.5]),
		Env([0.0, 0.0, 0.0], [450, 450]),
		Env([0.0, 0.0, 0.0], [450, 450]),
		Env([0.0, 0.0, 0.0], [562.5, 337.5]),
		Env([0.0, 0.0, 0.0], [675, 225]),
		Env([0.0, 0.0, 0.0], [787.5, 112.5])
	],
	[
		Env([0.0, 0.0, 0.0], [112.5, 787.5]),
		Env([0.0, 0.0, 0.0], [225, 675]),
		Env([0.0, 0.0, 0.0], [337.5, 562.5]),
		Env([0.0, 0.0, 0.0], [450, 450]),
		Env([0.0, 0.0, 0.0], [450, 450]),
		Env([0.0, 0.0, 0.0], [562.5, 337.5]),
		Env([0.0, 0.0, 0.0], [675, 225]),
		Env([0.0, 0.0, 0.0], [787.5, 112.5])
	],
	[
		Env([0.0, 0.0, 0.0], [112.5, 787.5]),
		Env([0.0, 0.0, 0.0], [225, 675]),
		Env([0.0, 0.0, 0.0], [337.5, 562.5]),
		Env([0.0, 0.0, 0.0], [450, 450]),
		Env([0.0, 0.0, 0.0], [450, 450]),
		Env([0.0, 0.0, 0.0], [562.5, 337.5]),
		Env([0.0, 0.0, 0.0], [675, 225]),
		Env([0.0, 0.0, 0.0], [787.5, 112.5])
	],
	[
		Env([0.0, 0.0, 0.0], [112.5, 787.5]),
		Env([0.0, 0.0, 0.0], [225, 675]),
		Env([0.0, 0.0, 0.0], [337.5, 562.5]),
		Env([0.0, 0.0, 0.0], [450, 450]),
		Env([0.0, 0.0, 0.0], [450, 450]),
		Env([0.0, 0.0, 0.0], [562.5, 337.5]),
		Env([0.0, 0.0, 0.0], [675, 225]),
		Env([0.0, 0.0, 0.0], [787.5, 112.5])
	]
],

// Amplitudes
amplitudes = [
	[0.1, 0.1, 0.02, 0.02, 0.1, 0.1, 0.02, 0.02],
	[0.1, 0.1, 0.02, 0.02, 0.1, 0.1, 0.02, 0.02],
	[0.1, 0.1, 0.02, 0.02, 0.1, 0.1, 0.02, 0.02],
	[0.1, 0.1, 0.02, 0.02, 0.1, 0.1, 0.02, 0.02],
	[0.1, 0.1, 0.02, 0.02, 0.1, 0.1, 0.02, 0.02]
],

// Pan positions
panPositions = [
	[-1.0, 1.0, -1.0, 1.0, -1.0, 1.0, -1.0, 1.0],
	[-1.0, 1.0, -1.0, 1.0, -1.0, 1.0, -1.0, 1.0],
	[-1.0, 1.0, -1.0, 1.0, -1.0, 1.0, -1.0, 1.0],
	[-1.0, 1.0, -1.0, 1.0, -1.0, 1.0, -1.0, 1.0],
	[-1.0, 1.0, -1.0, 1.0, -1.0, 1.0, -1.0, 1.0]
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
