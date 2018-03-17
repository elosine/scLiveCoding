(
s.waitForBoot{
	s.options.memSize = 81920;
}
)
(
p = ProxySpace.push(s);
s.meter;
Server.default.makeGui;
)

~out.ar(2);
~out.play;
~e0 = {|durden=30 atk=0.01 rel=0.73| EnvGen.ar(Env.perc(atk,rel), Dust.kr(1/durden) ) };
~s0 = {|den=30 pitch=71 amp=1| Formlet.ar( Dust.ar(den), pitch.midicps, 0.01, 0.05) };
~fx0 = {|in del=0.1 damp=0.2 sz=1 diff=0.1 fb=0.3 amp=1| Greyhole.ar(In.ar(in), del, damp, sz, diff, fb)*amp;};
~b01 = ~e0*~s0;


~fx0.set(\in, ~b01.bus.index);
~e0.set(\durden, 1)
~o0 = ~b01;
~o0 = ~fx0;
~o0 = ~fx0+~b01;
~out = ~o0;

~lf0={|dur=300 lo=30 hi=0.2| Phasor.ar(0, ( 1.0/(SampleRate.ir*dur) ) * (hi-lo), lo, hi)};
~e0.map(\durden, ~lf0);





~lf0.free

~o0=~fx0

~s1 = {|pitch=72 amp=0.3| SinOsc.ar(pitch.midicps)*amp};
~s1.free

~o1=~s1
~o1=nil
~out = ~o0


~s1 = { |pitch=60 amp=0.5| var freq=pitch.midicps; SinOsc.ar(freq)*amp};
~n1 = { |amp=0.5|  WhiteNoise.ar()*amp};

~l1 = {|dur=13 lo=0 hi=1| Phasor.ar(0, 1/(s.sampleRate*dur)).range(lo, hi)};

~l1.set(\dur, 1);
~l1.set(\lo, 0, \hi, 0.3);
~l1.map(\dur, ~lf1);
~l1.free

~lf1 = {|freq=0.1 lo=2 hi=21| SinOsc.ar(freq).range(lo, hi)};

~s1.map(\amp, ~l1);

~l1.free

~out = ~s1
~out = nil;