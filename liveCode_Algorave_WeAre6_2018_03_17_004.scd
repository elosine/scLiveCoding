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
~s0 = {|den=30 pitch=71 amp=4| Formlet.ar( Dust.ar(den), pitch.midicps, 0.01, 0.05) };
)
~b0=~s0*~e0;
~fx0 = {|in del=0.1 damp=0.2 sz=1 diff=0.9 fb=0.73 amp=1| Greyhole.ar(In.ar(in), del, damp, sz, diff, fb)*amp;};

~fx0.set(\in, ~b0.bus.index);

~o0=~fx0
~out = ~o0;

~pf0_0={|dur=300 lo=30 hi=0.2| Phasor.ar(0, ( 1.0/(SampleRate.ir*dur) ) * (hi-lo), lo, hi)};
~e0.map(\durden, ~lf0);

~r0_0 = {|lo=22 hi=90 den=8| TIRand.kr(lo, hi, Dust.kr(den))};
~s0.map(\pitch, ~r0_0);

~sf0_0 = {|freq=(1/24) lo=0.04 hi=0.5| SinOsc.ar(freq).range(lo, hi) };

////

~sq1_0 = { |pitch=68 wd1=0.5  wd2=0.5 wd3=0.5 amp=1| ( Pulse.ar(pitch.midicps, wd1, 0.02)+Pulse.ar((pitch-1).midicps, wd2, 0.02)+Pulse.ar((pitch-5).midicps, wd3, 0.02) )*amp };


Ndef(\dist, {|ot=99, in, drive=0.3, type=0,amp=1|
   var out;
   out = In.ar(in)*(((drive**2)+0.02)*50);
   out= SelectX.ar(type,[out.softclip, out.distort, out.clip(-1,1), out.fold(-1,1)]);
   out = out * ((amp**2)*(1-(drive/2.6)));
});

Ndef(\dist).set(\in, ~sq1_0.bus.index);
Ndef(\dist).play;
Ndef(\dist).stop;
Ndef(\dist).set(\drive,0.9);
Ndef(\dist).set(\type, 1);


~dist1_0 = \dist;
~dist1_0.set(\in, ~sq1_0.bus.index);

~out.ar(2);
~out.play
~o1 = ~sq1_0;
~o1 = ~dist1_0;
~out = ~o1

~out = nil

~dist1_0 = \dist;
~dist1_0.set(\in, ~sq1_0.bus.index);
~dist1_0.free

~gr1_0 = { |ifreq=7 dur=0.06 in pan=0 amp=1| GrainIn.ar(2, Impulse.kr(ifreq), dur, In.ar(in), pan)*amp};
~gr1_0.set(\amp, 2);

~r1_0 = {|lo=0.8 hi=23 den=0.5| TIRand.kr(lo, hi, Dust.kr(den))};
~gr1_0.map(\ifreq, ~r1_0);
~r1_0.set(\den, 0.65);

~gr1_0.free

~gr1_0.set(\in, ~sq1_0.bus.index);
~gr1_0.set(\in, ~dist1_0.bus.index);

~sf1_0 = {|freq=0.08) lo=0.1 hi=0.9| SinOsc.ar(freq).range(lo, hi) };
~sq1_0.map(\wd1, ~sf1_0)
~sq1_0.map(\wd2, ~sf1_0)
~sq1_0.map(\wd3, ~sf1_0)
~sf1_1 = {|freq=(1/24) lo=0.08 hi=33| SinOsc.ar(freq).range(lo, hi) };
~sf1_0.map(\freq, ~sf1_1)


~o1 = ~sq1_0;
~o1 = ~gr1_0;

~out= ~o0 + ~o1
