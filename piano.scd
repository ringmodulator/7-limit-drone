s.boot;

// Load samples
(
~notes = Array.new;
~folder = PathName.new("/Users/aaron/Dropbox/SuperCollider/7-limit-drone/samples/");
~folder.entries.do({
	arg path;
	~notes = ~notes.add(Buffer.read(s, path.fullPath));
});

// Sample playback synth
SynthDef.new(\piano, {
	arg amp = 1, out = 0, buf, rate = 1, da = 2, pan = 1;
	var sig;
	sig = PlayBuf.ar(2, buf, BufRateScale.kr(buf) * rate, doneAction:da) * amp;
	sig = Pan2.ar(sig, pan);
	Out.ar(out, sig);
}).add;
)

// Play a chord

(
Synth.new(\piano, [\buf, ~notes[0].bufnum, \rate, 1, \amp, 0.05]);
Synth.new(\piano, [\buf, ~notes[1].bufnum, \rate, 1, \amp, 0.05]);
Synth.new(\piano, [\buf, ~notes[2].bufnum, \rate, 1, \amp, 0.05]);
Synth.new(\piano, [\buf, ~notes[3].bufnum, \rate, 1, \amp, 0.05]);
Synth.new(\piano, [\buf, ~notes[4].bufnum, \rate, 1, \amp, 0.05]);
Synth.new(\piano, [\buf, ~notes[5].bufnum, \rate, 1, \amp, 0.05]);
Synth.new(\piano, [\buf, ~notes[8].bufnum, \rate, 1, \amp, 0.05]);
Synth.new(\piano, [\buf, ~notes[9].bufnum, \rate, 1, \amp, 0.05]);
)

// Play random notes, without repeating notes
// Can also use Pwrand to add weights to randomness
// Could use Ptuple to select chords to play.

(
p = Pbind(
	\instrument, \piano,
	\amp, Pwhite(0.2, 0.5),
	\buf, Pxrand(~notes, inf),
	\dur, Pwhite(0.0, 5.0)
	\pan, Pwhite(-0.8, 0.8),
).play;
)

p.stop;

