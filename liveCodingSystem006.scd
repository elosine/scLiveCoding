(
s.waitForBoot{fork{

	s.options.memSize = 81920;

	p = ProxySpace.push(s);
	0.1.wait;
	~o0.ar(2);~o1.ar(2);~o2.ar(2);~o3.ar(2);~o4.ar(2);~o5.ar(2);~o6.ar(2);~o7.ar(2);~o8.ar(2);~o9.ar(2);
	~out.ar(2);
	~out.play;
	~out = ~o0+~o1+~o2+~o3+~o4+~o5+~o6+~o7+~o8+~o9;

	a = Document.current.dir;

	c = SoundFile.collectIntoBuffers(a++ "/samples/*");
	 0.1.wait;
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

	d = SoundFile.collectIntoBuffers(a ++ "/grainEnv/*");

	SynthDef(\playSamp,  { |buf out=0 rate=1 amp=1| Out.ar( out, PlayBuf.ar(1, buf, rate, loop:1)*amp )}).add;

	SynthDef(\env, { |in=99 out=99, atk=0.01 sus=0.1 rel=0.03 rate=1 amp=1 type=0 crv= -4| var trig = Select.kr( type, [ Dust.kr(rate), Impulse.kr(rate) ] ); Out.ar( out, In.ar(in)*EnvGen.ar(Env.linen(atk, sus, rel,1,crv), trig  )*amp )}).add;

	SynthDef(\gh, {|in out del=0.25 dmp=0 sz=1 dif=0.707 fb=0.6 amp=1| Out.ar( out, Greyhole.ar( In.ar(in), del, dmp, sz, dif, fb)*amp ) }).add;
	SynthDef(\icy, {
		arg out, buf, amp = 1, envbuf = -1, pitchshift=1, winsz=0.8, overlaps=40, resettrig=0, startpos=0.0, endpos=1.0, rand=0.1, ratemin=5.0, ratemax=0.00001;
		var sig, ix, krate;
		krate = \rate.kr(1, 0.05).linlin(0.0, 1.0, ratemin, ratemax);
		ix = Phasor.kr(resettrig, ((1.0/ControlRate.ir)/(BufFrames.kr(buf)/SampleRate.ir))*krate, startpos, endpos);
		sig = Warp1.ar(1, buf, ix, pitchshift, winsz, envbuf, overlaps,rand);
		Out.ar(out, sig*amp);
	}).add;
	SynthDef(\rm,{
		arg in, out, buf, inamp=1, amp=1, mix=0.5, bend=1, lf1f=0.2, fb=1;
		var src, dfreq, hasFreq, damp, mod, rm, lf1;
		src = In.ar(in);
		src = src*inamp;
		# dfreq, hasFreq = Tartini.kr(src);
		damp = Amplitude.kr(src);
		lf1 = LFTri.kr(lf1f)*bend;
		mod = SinOscFB.ar( (dfreq.cpsmidi+lf1).midicps,fb )*damp;
		rm = DiodeRingMod.ar(src*mix, mod*(1-mix));
		Out.ar(out, rm*amp);
	}).add;
	SynthDef(\mGrain, {
		arg grdur1=0.05, envbuf1= -1, in=0, out=99, grate1=5, grdur2=0.05, envbuf2= -1, grate2=5, sr=3000, br=10, rez=0.4, gamp1=1, gamp2=1, s0=0, s1=0;
		var source, grain1, grain2, grain3, sig, grtr1,grtr2;
		grtr1 = Select.kr(s0, [ Impulse.kr(grate1), Dust.kr(grate1) ]);
		grtr2 = Select.kr(s1, [ Impulse.kr(grate2), Dust.kr(grate2) ]);
		source = In.ar(in);
		source = Greyhole.ar(source, 0.0, feedback:0.4);
		grain1 = GrainIn.ar(1, grtr1, grdur1, source, envbufnum:envbuf1);
		grain1 = Decimator.ar(grain1, sr, br);
		grain2 = GrainIn.ar(1, grtr2, grdur2, source, envbufnum:envbuf2);
		grain2 = DynKlank.ar(`[ [52+12, 53+12, 54+12, 57+12, 58+12, 59+12, 60+12, 63+12, 64+12, 52, 53, 54, 57, 58, 59, 60, 63, 64].midicps, (1.0/18)!18, rez!18  ], grain2 );
		sig = Mix.ar([grain1*gamp1, grain2*gamp2]);
		Out.ar(out, sig);
	}).add;

	SynthDef(\noise, {|out amp=0.2| Out.ar(out, PinkNoise.ar()*amp) }).add;
	SynthDef(\impulses, {|out type=0 rate=1 amp=1| var sig = Select.ar(type, [Impulse.ar(rate), Dust.ar(rate)] ); Out.ar(out, sig) });
	SynthDef(\drone1,  {|out pch=50 rate=0.06 dlo=0.97 dhi=1.1 mul=1| var freq= pch.midicps; Out.ar( out, DFM1.ar(SinOsc.ar([freq,freq*1.01]*mul,0,0.1), (freq*2)*mul, SinOsc.kr(rate).range(dlo, dhi),1,0,0.0003,0.5) )}).add;

	SynthDef(\pan2, {|in out pos=0 amp=1| Out.ar( out, Pan2.ar( In.ar(in), pos )*amp ) }).add;
	SynthDef(\stereo, {|in out del=0.015| Out.ar(out, [In.ar(in), DelayC.ar(In.ar(in), 0.2, del)] ) }).add;

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

	0.1.wait;

	~bowl = \playSamp; ~acc = \playSamp; ~muBox = \playSamp; ~saw = \playSamp; ~aeolian = \playSamp; ~bamboo = \playSamp; ~pans = \playSamp; ~glass = \playSamp; ~eGtr = \playSamp; ~post = \playSamp; ~sitar = \playSamp; ~squeek = \playSamp; ~rocks = \playSamp; ~type = \playSamp; ~match = \playSamp;

	0.1.wait;

	~bowl.set(\buf, b[\bowl]); ~acc.set(\buf, b[\accl]); ~muBox.set(\buf, b[\muBox]); ~saw.set(\buf, b[\saw]); ~aeolian.set(\buf, b[\aeolian]); ~bamboo.set(\buf, b[\bamboo]); ~pans.set(\buf, b[\pans]); ~glass.set(\buf, b[\glass]); ~eGtr.set(\buf, b[\eGtr]); ~post.set(\buf, b[\post]); ~sitar.set(\buf, b[\sitar]); ~squeek.set(\buf, b[\squeek]); ~rocks.set(\buf, b[\glass]); ~type.set(\buf, b[\type]); ~match.set(\buf, b[\match]);

}}
)
~bowl = \playSamp; ~bowl.set(\buf, b[\bowl]);

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
~e1.clear;

~e1.set(\rate, 2.5, \atk, 0.03, \sus, 0.07, \rel, 0.05, \crv, 0,  \type, 0); //reg atk=0.03, sus=dur, rel=0.05, crv=0
~e1.set(\rate, 5.5, \atk, 0.01, \sus, 0, \rel, 0.1, \crv, -8,  \type, 0); //perc atk=0.01, sus=0, rel=dur, crv=-4
~e1.set(\rate, 3, \atk, 0.6, \sus, 0, \rel, 0.01, \crv, 10,  \type, 0); //backwards atk=dur, sus=0, rel=0.01, crv=10
~muBox.set(\rate, -2)
~acc.set(\rate, 1.5)
~muBox.set(\rate, 3.5)

~fx1 = \gh
~fx1.set(\in, ~e1.bus.index);
~o0 = ~fx1
~fx1.set(\del, 0.25, \dmp, 0.0, \sz, 0.7, \fb, 0.7);
~fx1.clear;

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

~src2 = \icy
~src2.set(\buf, b[\muBox], \rate, 0.99, \pitchShift, 2);
~o1 = ~src2

~lfExp1.set(\rate, 0.05, \lo, 0.00001, \hi, 1);
~src2.map(\amp, ~lfExp1);
~src2.set(\amp, 0.2);
~src2.unmap(\amp);
~src2.free
~p2 = \pan2
~p2.set(\pos, 0);
~p2.set(\in, ~src2.bus.index);
~o1= ~p2
~lfSin1.set(\rate, 0.05, \lo, -1, \hi, 1);
~p2.map(\pos, ~lfSin1);

~o0=nil


~rm = \rm
~rm.set(\in, ~bowl.bus.index, \mix, 0.5, \inamp, 10, \amp, 0.5);
~bowl.set(\rate, 0.4)
~lfTRand1.set(\rate, 0.2, \lo, 0.2, \hi, 2);
~bowl.map(\rate, ~lfTRand1);
~bowl.unmap(\rate);
~o4 = ~rm
~o4 = nil
~o1 = ~e1
~o1.fadeTime = 3

~rm.clear

~lfSin2.set(\rate, 0.05, \lo, 0.1, \hi, 500);
~rm2.map(\fb, ~lfSin2);

~fx3 = \mGrain
~fx3.set(\in, ~acc.bus.index, \sr, 5000, \br, 12, \rez, 0.5, \gdur1, 0.1, \grdur2, 0.03, \grate1, 5, \grate2, 2, \s0, 0, \s1, 1);
~acc.set(\rate, 7.2)
~o1 = ~fx3
~fx3.clear
~lfSaw2.set(\rate, 0.03, \lo, 0.5, \hi, 20)
~fx3.map(\grate1, ~lfSaw2);

~fx4 = \gh
~fx4.set(\in, ~fx3.bus.index);
~o1 = ~fx4
~o0 = nil
~fx4.set(\del, 0.86, \dmp, 0.0, \sz, 0.5, \fb, 1);
~fx4.clear;
~lfSaw3.set(\rate, 0.09, \lo, 0.7, \hi, 0.2)
~fx4.map(\del, ~lfSaw3);
~fx4.unmap(\del)
~fx4.set(\amp, 0.1);
~lfExp2.set(\rate, 0.1, \lo, 0.0001, \hi, 0.1)
~fx4.map(\amp, ~lfExp2);
~lfTRand2.set(\rate, 0.2, \lo, 0.07, \hi, 0.5);
~lfExp2.map(\rate, ~lfTRand2);
~e2 = \env
~e2.set(\

	~rm2 = \rm
	~rm2.set(\in, ~fx3.bus.index, \mix, 0.5, \inamp, 10, \amp, 5, \fb, 1);
	~o1 = ~rm2
	~p3 = \pan2

	~p2 = \pan2
	~p2.set(\in, ~rm2.bus.index);
	~o1= ~p2
	~lfSin2.set(\rate, 0.05, \lo, -1, \hi, 1);
	~p2.map(\pos, ~lfSin1);
	~p2.clear

	~e2 = \env
	~e2.set(\in, ~saw.bus.index, \rate, 4.5, \atk, 0.01, \sus, 0.03, \rel, 0.01, \crv, 6,  \type, 0); //reg atk=0.03, sus=dur, rel=0.05, crv=0
	~e1.set(\rate, 5.5, \atk, 0.01, \sus, 0, \rel, 0.1, \crv, -8,  \type, 0); //perc atk=0.01, sus=0, rel=dur, crv=-4
	~e1.set(\rate, 3, \atk, 0.6, \sus, 0, \rel, 0.01, \crv, 10,  \type, 0); //backwards atk=dur, sus=0, rel=0.01, crv=10
	~o0 = ~e2
	~sawSt = \stereo
	~sawSt.set(\in, ~e2.bus.index)
	~o0 = ~sawSt
	~sawSt.clear
	~muBox.set(\rate, -2)
	~acc.set(\rate, 1.5)
	~e2.set(\amp, 0.7)

	~p3 = \pan2
	~p3.set(\in, ~e2.bus.index);
	~o0= ~p3
	~lfSin2.set(\rate, 0.1, \lo, -1, \hi, 1);
	~p3.map(\pos, ~lfSin1);
	~p3.clear

	~o3 = ~bowl

	~st1 = \stereo
	~st1.set(\in, ~bowl.bus.index)
	~o3 = ~st1
	~bowl.set(\rate, 1.31)
	~e2.set(\amp, 0.5)

	~d1 = \drone1
	~d1.set(\pch, 50, \mul, 1, \rate, 0.05, \dlo, 0.97, \dhi, 1.3)
	~o2 = ~d1
	~d1.clear







	