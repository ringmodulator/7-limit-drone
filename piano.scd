s.boot;

~notes = Array.new;
~folder = PathName.new("/Users/aaron/Dropbox/SuperCollider/7-limit-drone/samples/");
~folder.entries.do({
	arg path;
	~notes = ~notes.add(Buffer.read(s, path.fullPath));
});


SynthDef.new(\piano, {
	arg amp = 1, out = 0, buf, rate = 1, da = 2;
	var sig;
	sig = PlayBuf.ar(2, buf, BufRateScale.kr(buf) * rate, doneAction:da) * amp;
	Out.ar(out, sig);
}).add;


(
Synth.new(\piano, [\buf, ~notes[1].bufnum, \rate, 1, \amp, 0.75]);
)