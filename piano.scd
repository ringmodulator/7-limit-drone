s.boot;

~notes = Array.new;

~folder = PathName.new("/Users/aaron/Dropbox/SuperCollider/7-limit-drone/samples/");

(
~folder.entries.do({
	arg path;
	~notes = ~notes.add(Buffer.read(s, path.fullPath));
});
)

~notes[0].play;
~notes[1].play;

(
~notes[0].play;
~notes[1].play;
~notes[2].play;
~notes[3].play;
~notes[4].play;
)

(
~notes[5].play;
~notes[6].play;
~notes[7].play;
~notes[8].play;
~notes[9].play;
)