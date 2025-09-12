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
	var snd = LFTri.ar(freq, mul: amp);
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
	snd = snd * EnvGen.kr(env, gate, doneAction: Done.freeSelf);
	snd = Pan2.ar(snd, pan);
	Out.ar(out, snd);
	}
).add;
)


(
// Calculate note frequencies
var root = 124,
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

// In these next few variables, we'll make a simple "score"

freqs = [ // An array of arrays, so we can have chords
	[minorSeventh, (minorSeventh * 2) + 1],
	[root / 2, root + 1],
	[perfectFifth, minorSeventh],
	[root / 2, octave + 3]
],

ffreqs = [ // filter frequencies
    [minorSeventh * 4, minorSeventh * 8],
	[root * 8, root * 8],
	[minorSeventh * 4, perfectFifth * 4],
	[root * 4, (octave * 4) + 1]
],

// Pan positions
panPositions = [[-1.0, 1.0], [-0.5, 0.5], [-0.5, 0.5], [-1.0, 1.0]],

// How long to sustain a given chord
sustainTimes = [120, 120, 120, 120],

// How long to wait until the next chord is played
waitTimes = [60, 30, 15];

r = Routine({
	// loop through the frequency chords in our score
	// A: I'd rather loop through full sets of parameters for individual notes - look back at the solution for the E-A drone
	freqs.do({|fs, c|
		var synthGroup = Group(s), // create a group to play our synths on
		ffs = ffreqs.wrapAt(c), // get the ffreqs at the same index as the freqs (wrap if we have more freqs than ffreqs)
		pan = panPositions.wrapAt(c), // get pan positions for notes
		synths = fs.collect({|f, i| // collect all of the frequencies in a given chord. A: Need to understand collect better
			// play a synth for each frequency. This needs pan position and amplitude added back in.
			Synth(\drone, [
				\freq, f,
				\ffreq, ffs.wrapAt(i), // getting individual ffreqs
				\pan, pan.wrapAt(i), // get pan positions
				\atk, 10,
				\rel, 10,
				\resInputEnv, Env([0, 1.1, 0.8], [60, 60]) // we can set the envelope because of how we constructed the SynthDef, using a default value with 16 nodes
			], synthGroup); // synthGroup is the target, so each synth will play on the Group we just created
		});
		// sustain and release
		{
			sustainTimes.wrapAt(c).wait; // Sustain synths for the sustain time
			synthGroup.release; // Release synths
		}.fork; // .fork is a shortcut for creating a Routine and playing it immediately. It is the same as writing Routine({ "I am in the routine".postln; }).play;
		waitTimes.wrapAt(c).wait; // Wait to play the next note or chord in the score.
	});
});
)

// Play the routine
r.play