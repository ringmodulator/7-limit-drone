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

// Play random notes, without repeating notes
// Can also use Pwrand to add weights to randomness
// Could use Ptuple to select chords to play.
(
p = Pbind(
	\instrument, \piano,
	\amp, Pwhite(0.1, 0.2),
	\buf, Pxrand(~notes, inf),
	\dur, Pwhite(0.0, 3.0),
	\pan, Pwhite(-1.0, 1.0),
).play;
)

p.stop;

