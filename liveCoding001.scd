(
s.waitForBoot{
s.options.memSize = 81920;
~b = SoundFile.collectIntoBuffers("/Users/yangj14/Documents/GitHub/scLiveCoding/samples/*");
/*
	0  - accordianbreath1.wav
	1  - aeolianGuitar.wav
	2  - bamboocracking.aiff
	3  - clangingPans.wav
	4  - elecGuitar.wav
	5  - glassbreak
	6  - match
	7  - musicbox
	8  - post
	9  - rocks
	10 - singing bowl
	11 - sitar
	12 - squeakywood
	13 - tablesaw
	14 - typing
*/

~g = [Group.new(s)];
10.do{ |ix| ~g = ~g.add( Group.after(~g[ix]) ) };
}
)

~playSamp = { |buf och=0 rate=1 | Out.ar( och, PlayBuf.ar(1, buf, rate, loop:1) )};
SynthDef(\playSamp, { |buf och=0 rate=1 | Out.ar( och, PlayBuf.ar(1, buf, rate, loop:1) )} ).add;
c = Synth(\playSamp, [\buf, ~b[1], \och, 0, \rate, 1]);
~smp = { |buf och rate| ~playSamp.play(~g[3], args:[\buf, buf, \och, och, \rate, rate] ) };

a = ~smp.value(~b[1], 0, 1);
a.set(\rate,0.5);

~e0 = { |och, ich, atk=0.01, sus=0.08, rel=0.03 rate=1| Out.ar(och, In.ar(ich)*EnvGen.ar(Env.linen(atk, sus, rel), Dust.kr(rate) ) ) };

~l0 = { |och rate=1 lo= -1 hi=1| Out.kr(och, SinOsc.kr(rate).range(lo, hi) ) };

~f0 = { |och=0, ich, del=0.3, diff=0.707, fb=0.5| Out.ar(och, Greyhole.ar(In.ar(ich), del, diff, fb) ) };

a = ~s0.play(~g[3], args:[\buf, ~b[10]]);

a.set(\och, 30);
b = ~e0.play(~g[6], args:[\och, 0, \ich, 30, \rate, 20]) ;
b.set(\rate, 20, \sus, 0.03, \rel, 0.01);

l = ~l0.play(~g[2], args: [\rate, 0.1, \och, 0, \lo, 0.1, \hi, 20]);

a.map(\rate, 0);
l.set(\rate, 0.005);
b.set(\rate, 9);
b.set(\sus, 0.08);

b.set(\och, 31);
f = ~f0.play(~g[8], args: [\ich, 31]);
~lp1 = ~l0.play(~g[2], args: [\rate, 0.1, \och, 1, \lo, 0.01, \hi, 1]);
f.map(\del, 1);

t = {|ich och rate| rate.postln;};
t.value(5,3,4);


(
// synchronous as default values are known to language

f = { |synth|
        var x = (), d = SynthDescLib.global[synth.defName.asSymbol];
        d.notNil.if { d.controls.do { |c| x.put(c.name, c.defaultValue) } };
        x
};
)

f.(c)
f.(c)[\och];
f.(c).keys;
f.(c).values[0];
dictionary

