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
	arg out = [0, 1], freq = 440, ffreq = 880, amp = 0.1, atk = 10, sus = 10, rel = 10, pan = 0.0;
	var env = Env.new(levels: [0, 1, 1, 0], times: [atk, sus, rel], curve: \sine);
	var snd = LFTri.ar(freq, mul: amp);
	snd = MoogLadder.ar(in: snd, ffreq: ffreq, res: 0.9);
	snd = snd * EnvGen.kr(env, doneAction: 2);
	snd = Pan2.ar(snd, pan);
	Out.ar(out, snd);
	}
).add;
)


(
// Calculate 7-limit just chromatic pitches based on root frequency
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
octave = root * 2;

// Notes to test instrument
Synth.new(\drone, [\freq, root, \ffreq, (root * 4), \atk, 5, \sus, 120, \rel, 20, \amp, 0.5, \pan, -0.75]);
Synth.new(\drone, [\freq, perfectFifth, \ffreq, (perfectFifth * 4), \atk, 10, \sus, 120, \rel, 15, \amp, 0.5, \pan, 0.75]);
Synth.new(\drone, [\freq, minorSeventh, \ffreq, (minorSeventh * 4), \atk, 15, \sus, 120, \rel, 10, \amp, 0.5, \pan, -0.5]);
Synth.new(\drone, [\freq, octave, \ffreq, (octave * 4), \atk, 20, \sus, 120, \rel, 5, \amp, 0.5, \pan, 0.5]);
)