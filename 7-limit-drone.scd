s.boot;

/*

What I would like to do with this: Schedule a series of notes to be sent to this synth with the following parameters, so that I can create a drone composition with it:

1. Time note is triggered
2. Pitch frequency
3. Attack time
4. Decay time
5. Amplitude
6. Filter frequency
7. Envelope for filter resonance
8. Pan position

*/

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
	[root, perfectFifth],
	[minorSeventh, octave],
	[perfectFourth, majorSeventh],
	[root, perfectFifth, octave]
],
ffreqs = freqs * 4,
sustainTimes = [10, 7, 8, 20], // How long to sustain a given chord
waitTimes = [2, 6, 7, 12]; // How long to wait until the next chord is played

r = Routine({
	// loop through the frequency chords in our score
	freqs.do({|fs, c|
		var synthGroup = Group(s), // create a group to play our synths on
		ffs = ffreqs.wrapAt(c), // get the ffreqs at the same index as the freqs (wrap if we have more freqs than ffreqs)
		synths = fs.collect({|f, i| // collect all of the frequencies in a given chord. A: Need to understand collect better
			// play a synth for each frequency
			Synth(\drone, [
				\freq, f,
				\ffreq, ffs.wrapAt(i), // getting individual ffreqs
				\atk, 1,
				\rel, 1,
				\resInputEnv, Env([0, 1.1, 1.0], [1, 5]) // we can set the envelope because of how we constructed the SynthDef, using a default value with 16 nodes
			], synthGroup); // synthGroup is the target, so each synth will play on the Group we just created
		});
		// sustain and release
		{ // These synths will sustain for a period of time
			sustainTimes.wrapAt(c).wait;
			// and then be released
			synthGroup.release;
			// because we have a gate argument, we can free our synths using .release. This is equivalent to doing synthGroup.set(\gate, 0);
			// Since all of our synths are playing in the same group, we can just call .release on the group instead of each synth individually
		}.fork; // .fork is a shortcut for creating a Routine and playing it immediately.
		// It is the same as writing Routine({ "I am in the routine".postln; }).play;

		// Now, we can either .wait for the set wait times, or we can yield until specifically commanded to continue (using .play again)
		// inf.yield;
		waitTimes.wrapAt(c).wait;
	});
});
)

// Play the routine
r.play
// If we used inf.yield, we can advance to the next step by calling .play again
r.play