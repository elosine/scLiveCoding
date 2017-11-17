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

SynthDef(\env, { |in=99 out=99, atk=0.01 sus=0.1 rel=0.03 rate=1 amp=1 type=0 crv= -4| var trig = Select.kr( type, [ Dust.kr(rate), Impulse.kr(rate) ] ); Out.ar( out, In.ar(in)*EnvGen.ar(Env.linen(atk, sus, rel,1,crv), trig  )*amp )}).add;

SynthDef(\gh, {|in out del=0.25 dmp=0 sz=1 dif=0.707 fb=0.6 amp=1| Out.ar( out, Greyhole.ar( In.ar(in), del, dmp, sz, dif, fb)*amp ) }).add;

SynthDef(\pan2, {|in out pos=0| Out.ar( out, Pan2.ar( In.ar(in), pos ) ) }).add;

~lfGaussRand =  {|rate=2 lo=0 hi=1| TGaussRand.kr( lo, hi, Dust.kr(rate) )}; ~lfSin =  { |rate=1 lo= -1 hi=1|  SinOsc.kr(rate).range(lo, hi)  }; ~lfSaw =  { |rate=1 lo= -1 hi=1|  LFSaw.kr(rate).range(lo, hi)  }; ~lfTri =  { |rate=1 lo= -1 hi=1|  LFTri.kr(rate).range(lo, hi)  }; ~lfNoise =  { |rate=1 lo= -1 hi=1|  LFNoise0.kr(rate).range(lo, hi)  }; ~lfTRand =  {|rate=2 lo=0 hi=1| TRand.kr( lo, hi, Dust.kr(rate) )};
~lfGaussRand1 =  {|rate=2 lo=0 hi=1| TGaussRand.kr( lo, hi, Dust.kr(rate) )}; ~lfSin1 =  { |rate=1 lo= -1 hi=1|  SinOsc.kr(rate).range(lo, hi)  }; ~lfSaw1 =  { |rate=1 lo= -1 hi=1|  LFSaw.kr(rate).range(lo, hi)  }; ~lfTri1 =  { |rate=1 lo= -1 hi=1|  LFTri.kr(rate).range(lo, hi)  }; ~lfNoise1 =  { |rate=1 lo= -1 hi=1|  LFNoise0.kr(rate).range(lo, hi)  }; ~lfTRand1 =  {|rate=2 lo=0 hi=1| TRand.kr( lo, hi, Dust.kr(rate) )};
~lfGaussRand2 =  {|rate=2 lo=0 hi=1| TGaussRand.kr( lo, hi, Dust.kr(rate) )}; ~lfSin2 =  { |rate=1 lo= -1 hi=1|  SinOsc.kr(rate).range(lo, hi)  }; ~lfSaw2 =  { |rate=1 lo= -1 hi=1|  LFSaw.kr(rate).range(lo, hi)  }; ~lfTri2 =  { |rate=1 lo= -1 hi=1|  LFTri.kr(rate).range(lo, hi)  }; ~lfNoise2 =  { |rate=1 lo= -1 hi=1|  LFNoise0.kr(rate).range(lo, hi)  }; ~lfTRand2 =  {|rate=2 lo=0 hi=1| TRand.kr( lo, hi, Dust.kr(rate) )};
~lfGaussRand3 =  {|rate=2 lo=0 hi=1| TGaussRand.kr( lo, hi, Dust.kr(rate) )}; ~lfSin3 =  { |rate=1 lo= -1 hi=1|  SinOsc.kr(rate).range(lo, hi)  }; ~lfSaw3 =  { |rate=1 lo= -1 hi=1|  LFSaw.kr(rate).range(lo, hi)  }; ~lfTri3 =  { |rate=1 lo= -1 hi=1|  LFTri.kr(rate).range(lo, hi)  }; ~lfNoise3 =  { |rate=1 lo= -1 hi=1|  LFNoise0.kr(rate).range(lo, hi)  }; ~lfTRand3 =  {|rate=2 lo=0 hi=1| TRand.kr( lo, hi, Dust.kr(rate) )};
 ~lfGaussRand4 =  {|rate=2 lo=0 hi=1| TGaussRand.kr( lo, hi, Dust.kr(rate) )}; ~lfSin4 =  { |rate=1 lo= -1 hi=1|  SinOsc.kr(rate).range(lo, hi)  }; ~lfSaw4 =  { |rate=1 lo= -1 hi=1|  LFSaw.kr(rate).range(lo, hi)  }; ~lfTri4 =  { |rate=1 lo= -1 hi=1|  LFTri.kr(rate).range(lo, hi)  }; ~lfNoise4 =  { |rate=1 lo= -1 hi=1|  LFNoise0.kr(rate).range(lo, hi)  }; ~lfTRand4=  {|rate=2 lo=0 hi=1| TRand.kr( lo, hi, Dust.kr(rate) )};
~lfGaussRand5 =  {|rate=2 lo=0 hi=1| TGaussRand.kr( lo, hi, Dust.kr(rate) )}; ~lfSin5 =  { |rate=1 lo= -1 hi=1|  SinOsc.kr(rate).range(lo, hi)  }; ~lfSaw5 =  { |rate=1 lo= -1 hi=1|  LFSaw.kr(rate).range(lo, hi)  }; ~lfTri5 =  { |rate=1 lo= -1 hi=1|  LFTri.kr(rate).range(lo, hi)  }; ~lfNoise5 =  { |rate=1 lo= -1 hi=1|  LFNoise0.kr(rate).range(lo, hi)  }; ~lfTRand5 =  {|rate=2 lo=0 hi=1| TRand.kr( lo, hi, Dust.kr(rate) )};

~lfExp = { |rate=1 lo=0.000000001 hi=1.0| LinExp.kr( LFSaw.kr(rate), -1, 1, lo, hi ) };
~lfExp1 = { |rate=1 lo=0.000000001 hi=1.0| LinExp.kr( LFSaw.kr(rate), -1, 1, lo, hi ) };
~lfExp2 = { |rate=1 lo=0.000000001 hi=1.0| LinExp.kr( LFSaw.kr(rate), -1, 1, lo, hi ) };
~lfExp3 = { |rate=1 lo=0.000000001 hi=1.0| LinExp.kr( LFSaw.kr(rate), -1, 1, lo, hi ) };
~lfExp4 = { |rate=1 lo=0.000000001 hi=1.0| LinExp.kr( LFSaw.kr(rate), -1, 1, lo, hi ) };
~lfExp5 = { |rate=1 lo=0.000000001 hi=1.0| LinExp.kr( LFSaw.kr(rate), -1, 1, lo, hi ) };

)
/*}}
)*/
~bowl = \playSamp; ~bowl.set(\buf, b[\bowl]);
~acc = \playSamp; ~acc.set(\buf, b[\accl]);
~muBox = \playSamp; ~muBox.set(\buf, b[\muBox]);
~saw = \playSamp; ~saw.set(\buf, b[\saw]);
~aeolian = \playSamp; ~aeolian.set(\buf, b[\aeolian]);
~bamboo = \playSamp; ~bamboo.set(\buf, b[\bamboo]);
~pans = \playSamp; ~pans.set(\buf, b[\pans]);
~glass = \playSamp; ~glass.set(\buf, b[\glass]);
~eGtr = \playSamp; ~eGtr.set(\buf, b[\eGtr]);
~post = \playSamp; ~post.set(\buf, b[\post]);
~sitar = \playSamp; ~sitar.set(\buf, b[\sitar]);
~squeek = \playSamp; ~squeek.set(\buf, b[\squeek]);
~rocks = \playSamp; ~rocks.set(\buf, b[\glass]);
~type = \playSamp; ~type.set(\buf, b[\type]);
~match = \playSamp; ~type.set(\buf, b[\match]);

~o0.fadeTime= 1;

~o0 = ~bowl;
~o0 = ~acc;
~o0 = ~muBox;
~o0 = ~saw;
~o0 = ~aeolian
~o0 = ~bamboo
~o0 = ~pans
~o0=nil;

~e1 = \env
~e1.set(\in, ~muBox.bus.index);
~o0 = ~e1

~e1.set(\rate, 2.5, \atk, 0.03, \sus, 0.07, \rel, 0.05, \crv, 0,  \type, 0); //reg atk=0.03, sus=dur, rel=0.05, crv=0
~e1.set(\rate, 13.5, \atk, 0.01, \sus, 0, \rel, 0.02, \crv, -8,  \type, 0); //perc atk=0.01, sus=0, rel=dur, crv=-4
~e1.set(\rate, 1.8, \atk, 0.5, \sus, 0, \rel, 0.01, \crv, 10,  \type, 0); //backwards atk=dur, sus=0, rel=0.01, crv=10
~muBox.set(\rate, -3.5)
~acc.set(\rate, 1.5)
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


~lfSin.set(\rate, 0.01, \lo, -5.5, \hi, 5.5);
~lfSaw.set(\rate, 0.1, \lo, -1, \hi, -5);
~lfGaussRand.set(\rate, 0.5, \lo, 0.4, \hi, 6);
~glass.xmap(\rate, ~lfGaussRand);
~muBox.xmap(\rate, ~lfGaussRand);
~muBox.unmap(\rate);

~lfSin.set(\rate, 0.2, \lo, -1, \hi, 1);
~p1.map(\pos, ~lfSin);
~p1.unmap(\pos);

~lfExp.set(\rate, 0.3, \lo, 0.00001, \hi, 1);
~e1.map(\amp, ~lfExp);
~e1.unmap(\amp);
~e1.set(\amp, 0.01);

(
b = Buffer.read(s, "/Volumes/Ute/Freeze/204497__holadios__short-giggle.wav");
d = SoundFile.collectIntoBuffers("/Volumes/Ute/Freeze/grainEnv/" ++ "*");
e = Buffer.read(s, "/Volumes/Ute/Freeze/acjourney.aif");

f = Buffer.read(s,"/Users/yangj14/Documents/GitHub/scLiveCoding/samples/accordianbreath1.wav");

SynthDef(\icy, {
	arg buf=0, envbuf = -1, pitchshift=1, winsz=0.8, overlaps=40, resettrig=0, startpos=0.0, endpos=1.0, rand=0.1, ratemin=2.0, ratemax=0.00001;
	var sig, ix, krate;
	krate = \rate.kr(1, 0.05).linlin(0.0, 1.0, ratemin, ratemax);
	ix = Phasor.kr(resettrig, ((1.0/ControlRate.ir)/(BufFrames.kr(buf)/SampleRate.ir))*krate, startpos, endpos);
	sig = Warp1.ar(1, buf, ix, pitchshift, winsz, envbuf, overlaps,rand);
	Out.ar(0, sig);
}).add;
)

x = Synth(\icy, [\buf, f, \winsz, 0.8, \overlaps, 33, \rand, 0.2])
x.set(\winsz, 0.8, \overlaps, 50, \startpos, 0, \endpos, 1, \pitchshift, 1, \envbuf, -1, \ratemin,1, \ratemax, 0.00001)
x.set( \rate, 0.8 );

x.map(\rate, ~kbs[0]);
x.free;




