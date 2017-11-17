/*(
s.waitForBoot{fork{*/

s.options.memSize = 81920;
s.options.numAudioBusChannels =
(
p = ProxySpace.push(s);
~o0.ar(2);~o1.ar(2);~o2.ar(2);~o3.ar(2);~o4.ar(2);~o5.ar(2);~o6.ar(2);~o7.ar(2);~o8.ar(2);~o9.ar(2);
~out.ar(2);
~out.play;
~out = ~o0+~o1+~o2+~o3+~o4+~o5+~o6+~o7+~o8+~o9;

a = Document.current.dir ++ "/samples/*";

c = SoundFile.collectIntoBuffers(a);
// 0.1.wait;
//make sure all samples are mono
c.do{|it ix|
	if(it.numChannels==2, {
		it.loadToFloatArray( action: { |array|
			var a1 = array;
			var newBuf;
			{c[ix] = Buffer.loadCollection(s, a1.unlace(2).sum*0.5);}.defer;

		});
	});
};
b=(); b.add(\acc -> c[0]); b.add(\aeolian -> c[1]); b.add(\bamboo -> c[2]);b.add(\pans -> c[3]);b.add(\eGtr -> c[4]);b.add(\glass -> c[5]);b.add(\match -> c[6]);b.add(\muBox -> c[7]);b.add(\post -> c[8]);b.add(\rocks -> c[9]);b.add(\bowl -> c[10]);b.add(\sitar -> c[11]);b.add(\squeek -> c[12]);b.add(\saw -> c[13]); b.add(\type -> c[14]);

SynthDef(\playSamp,  { |buf out=0 rate=1 amp=1| Out.ar( out, PlayBuf.ar(1, buf, rate, loop:1)*amp )}).add;

SynthDef(\envS, { |in=99 out=99, atk=0.01 sus=0.1 rel=0.03 rate=1 amp=1 type=0 crv= -4| var trig = Select.kr( type, [ Dust.kr(rate), Impulse.kr(rate) ] ); Out.ar( out, In.ar(in)*EnvGen.ar(Env.linen(atk, sus, rel,1,crv), trig  ) )}).add;

SynthDef(\gh, {|in out del=0.25 dmp=0 sz=1 dif=0.707 fb=0.6 amp=1| Out.ar( out, Greyhole.ar( In.ar(in), del, dmp, sz, dif, fb) ) }).add;

SynthDef(\pan2, {|in out pos=0| Out.ar( out, Pan2.ar( In.ar(in), pos ) ) }).add;

~lfGaussRand =  {|rate=2 lo=0 hi=1| TGaussRand.kr( lo, hi, Dust.kr(rate) )};
~lfSin =  { |rate=1 lo= -1 hi=1|  SinOsc.kr(rate).range(lo, hi)  };
~lfSaw =  { |rate=1 lo= -1 hi=1|  LFSaw.kr(rate).range(lo, hi)  };


SynthDef(\lfSin,  { |out rate=1 lo= -1 hi=1|  Out.kr( out, SinOsc.kr(rate).range(lo, hi) ) }).add;

)
/*}}
)*/
~bowl = \playSamp; ~bowl.set(\buf, b[\bowl]);
~acc = \playSamp; ~acc.set(\buf, b[\accl]);
~muBox = \playSamp; ~muBox.set(\buf, b[\muBox]);
~saw = \playSamp; ~saw.set(\buf, b[\saw]);
~aeolian = \playSamp; ~aeolian.set(\buf, b[\aeolian]);

~o0.fadeTime= 2;

~o0 = ~bowl;
~o0 = ~acc;
~o0 = ~muBox;
~o0 = ~saw;
~o0 = ~aeolian
~o0=nil;

~e1 = \envS
~e1.set(\in, ~muBox.bus.index);
~o0 = ~e1

~e1.set(\rate, 1.5, \sus, 0.08, \type, 0)
~muBox.set(\rate, -2.5)
~acc.set(\rate, -3.5)
~muBox.set(\rate, 3.5)

~fx1 = \gh
~fx1.set(\in, ~e1.bus.index);
~o0 = ~fx1
~fx1.set(\del, 0.25, \dmp, 0.0, \sz, 0.7, \fb, 0.7);

~p1 = \pan2
~p1.set(\in, ~fx1.bus.index);
~p1.set(\in, ~e1.bus.index);
~o0 = ~p1
~p1.set(\pos, -1)
~p1.set(\pos, 1)
~p1.set(\pos, 0)


~lfSin.set(\rate, 0.001, \lo, -5.5, \hi, 5.5);
~lfSaw.set(\rate, 0.1, \lo, -1, \hi, -5);
~lfGaussRand.set(\rate, 0.5, \lo, 0.4, \hi, 6);
~muBox.xmap(\rate, ~lfGaussRand);
~muBox.unmap(\rate);

~lfSin.set(\rate, 0.001, \lo, -5.5, \hi, 5.5);
~p1.map(\pos, ~lf1_8);
~p1.unmap






