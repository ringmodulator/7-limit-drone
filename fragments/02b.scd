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

freqs = [ // oscillator frequencies - consider adding another root that covers all of these...
	[perfectFifth, perfectFifth + 1],
	[minorThird, minorThird + 0.5],
	[perfectFourth, perfectFourth + 2],
],

ffreqs = [ // filter frequencies
	[perfectFifth * 4, perfectFifth * 8],
	[minorThird * 8, minorThird * 4],
	[perfectFourth * 4, perfectFourth * 8],
],

// Attack times
attackTimes = [60, 60, 60],

// Sustain times
sustainTimes = [180, 180, 180],

// Release times
releaseTimes = [60, 60, 60],

// How long to wait until the next chord is played
waitTimes = [100, 100],

resEnvs = [ // Resonance envelopes
	[Env([0.0, 0.8, 0.5], [150, 150])],
	[Env([0.0, 1.3, 0.5], [150, 150])],
	[Env([0.5, 0.8, 0.0], [150, 150])],
],

// Amplitudes
amplitudes = [[0.5, 0.5], [0.5, 0.5], [0.5, 0.5]],

// Pan positions
panPositions = [[-0.5, 0.5], [-0.5, 0.5], [0.5, 0.5]];

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