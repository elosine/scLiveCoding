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
(
~out.ar(2);
~out.play;
~e0 = {|durden=30 atk=0.01 rel=0.73| EnvGen.ar(Env.perc(atk,rel), Dust.kr(1/durden) ) };
~s0 = {|den=30 pitch=71 amp=1| Formlet.ar( Dust.ar(den), pitch.midicps, 0.01, 0.05) };

)
~b0=~s0*~e0;
~fx0 = {|in del=0.1 damp=0.2 sz=1 diff=0.9 fb=0.73 amp=1.7| Greyhole.ar(In.ar(in), del, damp, sz, diff, fb)*amp;};

~fx0.set(\in, ~b0.bus.index);

~o0=~fx0
~out = ~o0;

~lf0={|dur=300 lo=30 hi=0.2| Phasor.ar(0, ( 1.0/(SampleRate.ir*dur) ) * (hi-lo), lo, hi)};
~e0.map(\durden, ~lf0);


~fx0.set(\fb, 0.780, \amp, 2.5, \diff, 0.91, \del, 0.1)

~s0 = {|den=30 pitch=71 amp=1| Formlet.ar( Dust.ar(den), pitch.midicps, 0.01, 0.05) };

~r0_0 = {|lo=22 hi=90 den=13| TIRand.kr(lo, hi, Dust.kr(den))};

~s0.map(\pitch, ~r0_0);

~lf0_0 = {|freq=(1/24) lo=0.04 hi=0.5| SinOsc.ar(freq).range(lo, hi) };
~fx0.map(\del, ~lf0_0);

~lf0_1 = {|freq=(1/44) lo=0.1 hi=0.9| SinOsc.ar(freq).range(lo, hi) };
~fx0.map(\diff, ~lf0_1);


//////////

~gr1_0= {|in den=13 dur=0.04 pan=0 amp=0.1| GrainIn.ar(2, Dust.kr(den), dur, In.ar(in), pan)*amp};


~sq1_0 = { |pitch=68 wd=0.5 amp=0.001| Pulse.ar(pitch.midicps, wd)*amp };

~lf1_0 = {|freq=(1/43) lo=33 hi=88| SinOsc.ar(freq).range(lo, hi) };

~sq1_0.map(\pitch, ~lf1_0);

~lf1_1 = {|freq=(75) lo=0.1 hi=0.98| SinOsc.ar(freq).range(lo, hi) };

~sq1_0.map(\wd, ~lf1_1);

~r1_0 = {|lo=0.5 hi=60 den=3| TIRand.kr(lo, hi, Dust.kr(den))};
~r1_0.set(\den, 0.5, \hi, 540, \lo, 0.001);
~lf1_1.map(\freq, ~r1_0);


~sq1_0.free

~gr1_0.free

~sq1_0.set(\amp, 0.3)

~gr1_0.set(\den, 3.1)

~lf1_3={|dur=120 lo=0.001 hi=13| Phasor.ar(0, ( 1.0/(SampleRate.ir*dur) ) * (hi-lo), lo, hi)};

~lf1_3.set(\hi, 5, \lo, 0.0001);
~gr1_0.map(\den, ~lf1_3)


~gr1_0.set(\in, ~sq1_0.bus.index);

~gr1_0= {|in den=13 dur=0.04 pan=0 amp=0.1| GrainIn.ar(2, Dust.kr(den), dur, In.ar(in), pan)*amp};

~r1_2 = {|lo=0.032 hi=0.8 den=0.5| TIRand.kr(lo, hi, Dust.kr(den))};
~r1_2.set(\hi, 0.9, \lo, 0.3)
~gr1_0.map(\dur, ~r1_2);



~o1 = ~gr1_0;
~o1 = ~sq1_0;

~out= ~o0+ ~o1