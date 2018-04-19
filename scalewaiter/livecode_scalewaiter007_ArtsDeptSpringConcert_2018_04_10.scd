

(
fork{
	~o0.ar(2); ~o1.ar(2);
	~os3.ar(2); ~o4.ar(2); ~o5.ar(2); ~o6.ar(2); ~o7.ar(2); ~o8.ar(2); ~o9.ar(2); ~o10.ar(2); ~o11.ar(2); ~o12.ar(2); ~o13.ar(2); ~o14.ar(2);
	~out.ar(2);
	~out.play;
	~out = ~o0+~o1+~o2+~o3+~o4+~o5+~o6+~o7+~o8+~o9+~o10+~o11+~o12+~o13+~o14;

	0.1.wait;
	~s0.ar(2);
	~s0.play(0);
	0.1.wait;
	~s1.ar(2);
	~s1.play(1);
	~s2.ar(2);
	~s2.play(2);
	0.1.wait;
	~s3.ar(2);
	~s3.play(3);
	0.1.wait;
	~s4.ar(2);
	~s1.play(4);
	0.1.wait;
	~s1.ar(5);
	~s1.play(5);
	0.1.wait;
	~s1.ar(6);
	~s1.play(6);
	0.1.wait;
	~s1.ar(7);
	~s1.play(7);

	0.1.wait;

	~o0.fadeTime = 2; ~o1.fadeTime = 3; ~o2.fadeTime = 1.9; ~o3.fadeTime = 2.3; ~o4.fadeTime = 2; ~o5.fadeTime = 3; ~o6.fadeTime = 2; ~o7.fadeTime = 2; ~o8.fadeTime = 2;


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

	0.1.wait;


	b=(); b.add(\acc -> c[0]); b.add(\aeolian -> c[1]); b.add(\bamboo -> c[2]);b.add(\pans -> c[3]);b.add(\egtr -> c[4]);b.add(\glass -> c[5]);b.add(\match -> c[6]);b.add(\mubox -> c[7]);b.add(\post -> c[8]);b.add(\rocks -> c[9]);b.add(\bowl -> c[10]);b.add(\sitar -> c[11]);b.add(\squeek -> c[12]);b.add(\saw -> c[13]); b.add(\type -> c[14]);

	0.1.wait;
	d = SoundFile.collectIntoBuffers(a ++ "/grainEnv/*");

	0.1.wait;


	Ndef(\playSamp,  { |buf rate=1 amp=1| PlayBuf.ar(1, buf, rate, loop:1)*amp });

	0.1.wait;

	Ndef(\playSamp).copy(\bowl);
	Ndef(\bowl).set(\buf, b[\bowl]);
	Ndef(\playSamp).copy(\acc);
	Ndef(\acc).set(\buf, b[\acc]);
	Ndef(\playSamp).copy(\mubox);
	Ndef(\mubox).set(\buf, b[\mubox]);
	Ndef(\playSamp).copy(\saw);
	Ndef(\saw).set(\buf, b[\saw]);
	Ndef(\playSamp).copy(\aeolian);
	Ndef(\aeolian).set(\buf, b[\aeolian]);
	Ndef(\playSamp).copy(\bamboo);
	Ndef(\bamboo).set(\buf, b[\bamboo]);
	Ndef(\playSamp).copy(\pans);
	Ndef(\pans).set(\buf, b[\pans]);
	Ndef(\playSamp).copy(\glass);
	Ndef(\glass).set(\buf, b[\glass]);
	Ndef(\playSamp).copy(\egtr);
	Ndef(\egtr).set(\buf, b[\egtr]);
	0.1.wait;
	Ndef(\playSamp).copy(\post);
	Ndef(\post).set(\buf, b[\post]);
	Ndef(\playSamp).copy(\sitar);
	Ndef(\sitar).set(\buf, b[\sitar]);
	Ndef(\playSamp).copy(\squeek);
	Ndef(\squeek).set(\buf, b[\squeek]);
	Ndef(\playSamp).copy(\rocks);
	Ndef(\rocks).set(\buf, b[\rocks]);
	Ndef(\playSamp).copy(\type);
	Ndef(\type).set(\buf, b[\type]);
	Ndef(\playSamp).copy(\match);
	Ndef(\match).set(\buf, b[\match]);


	0.1.wait;



	Ndef(\env, { |in=0 atk=0.001 sus=0.0 rel=0.08 lvl=1 rate=1 amp=1 type=0 crv= -4| var trig = Select.kr( type, [ Dust.kr(rate), Impulse.kr(rate) ] );  {In.ar(in)*EnvGen.ar(Env.linen(atk, sus, rel,lvl,crv), trig  )*amp }});

	Ndef(\grainy, {|in type=0 rate=1 dur=0.1 envbuf= -1 pan= -1 amp=1 | {GrainIn.ar(1, Select.kr( type, [ Dust.kr(rate), Impulse.kr(rate) ] ), dur, In.ar(in), pan, envbuf)*amp}});



	0.1.wait;

	////////////////////////////////////////////////////////////


	//4)
	Ndef(\gh, {|in del=0.25 dmp=0.1 sz=1 dif=0.707 fb=0.6 amp=1|  Greyhole.ar( In.ar(in), del, dmp, sz, dif, fb)*amp  });

	Ndef(\icy, {
		arg buf, amp = 1, envbuf = -1, pitchshift=1, winsz=0.8, overlaps=40, resettrig=0, startpos=0.0, endpos=1.0, rand=0.1, ratemin=5.0, ratemax=0.00001;
		var sig, ix, krate;
		krate = \rate.kr(1, 0.05).linlin(0.0, 1.0, ratemin, ratemax);
		ix = Phasor.kr(resettrig, ((1.0/ControlRate.ir)/(BufFrames.kr(buf)/SampleRate.ir))*krate, startpos, endpos);
		sig = Warp1.ar(1, buf, ix, pitchshift, winsz, envbuf, overlaps,rand);
		{sig*amp};
	});

	Ndef(\rm,{
		arg ibs, inamp=1, amp=1, mix=0.5, bend=1, lf1f=0.2, fb=1;
		var src, dfreq, hasFreq, damp, mod, rm, lf1;
		src = In.ar(ibs);
		src = src*inamp;
		# dfreq, hasFreq = Tartini.kr(src);
		damp = Amplitude.kr(src);
		lf1 = LFTri.kr(lf1f)*bend;
		mod = SinOscFB.ar( (dfreq.cpsmidi+lf1).midicps,fb )*damp;
		rm = DiodeRingMod.ar(src*mix, mod*(1-mix));
		{ rm*amp};
	});

	Ndef(\dist, {|in=4 drive=0.9 type=2 amp=1|
		var sig;
		sig = In.ar(in, 2)*(((drive**2)+0.02)*50);
		sig= SelectX.ar( type, [sig.softclip, sig.distort, sig.clip(-1,1), sig.fold(-1,1)]);
		{sig * ((amp**2)*(1-(drive/2.6)))};
	});



	Ndef(\lfGaussRand,   {|rate=2 lo=0 hi=1| TGaussRand.kr( lo, hi, Dust.kr(rate) )});
	Ndef(\lfSin,  { |rate=1 lo= -1 hi=1|  SinOsc.kr(rate).range(lo, hi)  });
	Ndef(\lfPhasor,  { |dur=300 lo=30 hi=0.2| Phasor.ar(0, ( 1.0/(SampleRate.ir*dur) ) * (hi-lo), lo, hi)});
	Ndef(\lfSaw,  { |rate=1 lo= -1 hi=1|  LFSaw.kr(rate).range(lo, hi)  });
	Ndef(\lfTri,  { |rate=1 lo= -1 hi=1|  LFTri.kr(rate).range(lo, hi)  });
	Ndef(\lfNoise,  { |rate=1 lo= -1 hi=1|  LFNoise0.kr(rate).range(lo, hi)  });
	Ndef(\lfTRand,  {|rate=2 lo=0 hi=1| TRand.kr( lo, hi, Dust.kr(rate) )});
	Ndef(\lfTIRand,  {|rate=2 lo=0 hi=1| TIRand.kr( lo, hi, Dust.kr(rate) )});
	Ndef(\lfExp, { |rate=1 lo=0.000000001 hi=1.0| LinExp.kr( LFSaw.kr(rate), -1, 1, lo, hi ) };);



	//Enveloper
	Ndef(\appear,  {  | amp=1 cycdurminutes=10 cyclo=42.0 cychi=0.2 waitdurrandrange=0|
		var trig=0, twaitdur, env, waitcyc;
		var cycrate = 1.0/(cycdurminutes*60);
		var envtype = TIRand.ar( 0, 3, Dust.ar( TRand.ar( (1/3.7), (1/5.1), Dust.ar( (1/7) ) ) ) );
		var dur = TChoose.kr( Dust.kr( TRand.kr( (1/3.2), 3, Dust.kr( (1/8.5) ) ) ), [0.05, 0.123, 0.54, 1.07, 3.4, 0.21, 0.064, 0.31, 0.85] );
		var atk = TChoose.kr( Dust.kr( TRand.kr( (1/4.7), 1, Dust.kr( (1/6.2) ) ) ), [0.03, 0.11, 0.47, 0.038, 0.012, 0.05, 0.22] );
		var rel = TChoose.kr( Dust.kr( TRand.kr( (1/2.1), 3.6, Dust.kr( (1/3.16) ) ) ), [0.03, 0.092, 0.7, 0.041, 0.13, 0.048, 0.22] );
		var crv = TChoose.kr( Dust.kr( TRand.kr( (1/7.1), (1/4.21), Dust.kr( (1/9.62) ) ) ), [-4, 4.4, -3, 4.8, 0, 2, -1] );
		var sus = TChoose.kr( Dust.kr( TRand.kr( (1/8.1), (1/1.4), Dust.kr( (1/3.22) ) ) ), [0.92, 4.72, 1.48, 0.061, 0.87, 3.92] );
		waitcyc = LFSaw.ar( cycrate, 1 ).range( cyclo, cychi );
		twaitdur = TRand.ar(  waitcyc, (waitcyc+waitdurrandrange), Impulse.ar(30) );
		trig = TDelay.ar( Impulse.ar( ( cyclo - (cyclo/2)  ) ), twaitdur  ) ;
		env = Select.ar( envtype, [
			EnvGen.ar( Env.sine(dur), trig),
			EnvGen.ar( Env.perc(atk, rel, 1, crv), trig),
			EnvGen.ar( Env.triangle(dur), trig),
			EnvGen.ar( Env.linen(atk, sus, rel, 1, crv), trig)
		] );
		{ env };
	});

	0.1.wait;
	Ndef(\appear).copy(\env0);
	Ndef(\appear).copy(\env1);
	Ndef(\appear).copy(\env2);
	Ndef(\appear).copy(\env3);
	Ndef(\appear).copy(\env4);
	Ndef(\appear).copy(\env5);
	Ndef(\appear).copy(\env6);
	Ndef(\appear).copy(\env7);
	Ndef(\appear).copy(\env8);
	Ndef(\appear).copy(\env9);
	Ndef(\appear).copy(\env10);
	Ndef(\appear).copy(\env11);
	Ndef(\appear).copy(\env12);
	Ndef(\appear).copy(\env13);
	Ndef(\appear).copy(\env14);
	Ndef(\appear).copy(\env15);
	Ndef(\appear).copy(\env16);
	Ndef(\appear).copy(\env17);
	Ndef(\appear).copy(\env18);
	Ndef(\appear).copy(\env19);
	Ndef(\appear).copy(\env20);
	Ndef(\appear).copy(\env21);

	0.1.wait;
	Ndef(\env0).set(\cycdurminutes, 10, \cyclo, 42.0, \cychi, 0.2, \waitdurrandrange, 2);
	Ndef(\env1).set(\cycdurminutes, 8, \cyclo, 27.0, \cychi, 0.4, \waitdurrandrange, 0);
	Ndef(\env2).set(\cycdurminutes, 14, \cyclo, 51.0, \cychi, 3.4, \waitdurrandrange, 2.2);
	Ndef(\env3).set(\cycdurminutes, 11.8, \cyclo, 35, \cychi, 2, \waitdurrandrange, 0.5);
	Ndef(\env4).set(\cycdurminutes, 13.3, \cyclo, 22, \cychi, 7.3, \waitdurrandrange, 0.85);
	Ndef(\env5).set(\cycdurminutes, 9.3, \cyclo, 39, \cychi, 0.12, \waitdurrandrange, 0);



	//Record Mouse

	Ndef(\recms,  { | buf | RecordBuf.kr( MouseX.kr(lag:0.01), buf, loop:0, doneAction:2) });

	Ndef(\playkrbuf, { | buf rate=1 loop=1 | PlayBuf.kr(1, buf, rate, loop:loop) });

	Ndef(\stpan, { | ibs rate=0.023809523809524 amp=0.3 | var panner = SinOsc.ar(rate);
		{PanAz.ar( 8, panner, In.ar(ibs) )} });

	Ndef(\stpan).copy(\pan0);
	Ndef(\stpan).copy(\pan1);
	Ndef(\stpan).copy(\pan2);
	Ndef(\stpan).copy(\pan3);
	Ndef(\stpan).copy(\pan4);
	Ndef(\stpan).copy(\pan5);
	Ndef(\stpan).copy(\pan6);
	Ndef(\stpan).copy(\pan7);
	Ndef(\stpan).copy(\pan8);


	~src0_0 = Ndef(\mubox); //musicbox w/speed changes

	Ndef(\choice, {TChoose.kr( Dust.kr( TRand.kr( (1/15.2), (1/5.4), Dust.kr( (1/11.5) ) ) ), [0.13, -0.123, 7.5, -6.1, 0.2, -0.07, 0.064, 0.31, -0.85] );});
	0.1.wait;
	Ndef(\mubox).map( \rate, Ndef(\choice) );

	//music box w/ greyhole
	Ndef(\gh).copy(\gh0);
	0.1.wait;
	Ndef(\gh0).set(\in, Ndef(\mubox).bus.index, \del, 1.5, \dmp, 0.2, \sz, 1.3, \dif, 0.2, \fb, 0.8, \amp, 0.37);
	~src0_1 = Ndef(\gh0);
	//modulate delay rate
	Ndef(\lfSin0,  { |rate=0.03 lo= 0.01 hi=1.4|  SinOsc.kr(rate).range(lo, hi) });
	0.1.wait;
	Ndef(\gh0).map(\del, Ndef(\lfSin0));
	//modulate diff
	Ndef(\lfTRand0,  { | rate=0.125 lo=0.1 hi=0.91 | TRand.kr( lo, hi, Dust.kr(rate) ) });
	0.1.wait;
	Ndef(\gh0).map(\dif, Ndef(\lfTRand0));


	//bowl
	~src1_0 = Ndef(\bowl);
	Ndef(\lfSaw0,  { | rate=0.01125 lo= 2.3 hi=0.6|  LFSaw.kr(rate).range(lo, hi)  });
	0.1.wait;
	Ndef(\bowl).map(\rate, Ndef(\lfSaw0));

	//granulation
	Ndef(\grainy).copy(\grainy0);
	0.1.wait;
	Ndef(\grainy0).set(\in, Ndef(\bowl).bus.index, \type, 0, \rate, 30, \pan, 1, \dur, 0.05, \envbuf, d[3], \amp, 0.5 );
	0.1.wait;
	~src1_1 = Ndef(\grainy0);

	//modulate rate
	Ndef(\lfPhasor0,  { |dur=27 lo=3 hi=17| Phasor.ar(0, ( 1.0/(SampleRate.ir*dur) ) * (hi-lo), lo, hi)});
	0.1.wait;
	Ndef(\grainy0).map(\rate, Ndef(\lfPhasor0));

	//modulate grain dur
	Ndef(\lfNoise0,  { |rate=0.3 lo= 0.08 hi=0.4|  LFNoise0.kr(rate).range(lo, hi)  });
	0.1.wait;
	Ndef(\grainy0).map(\dur, Ndef(\lfNoise0));


	//Aeolian
	~src2_0 = Ndef(\aeolian);
	Ndef(\lfSin3,  { | rate=0.002 lo= 0.01 hi=4|  LFSaw.kr(rate).range(lo, hi)  });
	0.1.wait;
	Ndef(\aeolian).map(\rate, Ndef(\lfSin3));

	//granulation
	Ndef(\grainy).copy(\grainy1);
	0.1.wait;
	Ndef(\grainy1).set(\in, Ndef(\aeolian).bus.index, \type, 1, \rate, 30, \pan, 1, \dur, 0.08, \envbuf, d[8], \amp, 1 );

	~src2_1 = Ndef(\grainy1);

	//modulate rate
	Ndef(\lfExp0, { |rate=0.027 lo=0.8 hi=30| LinExp.kr( LFSaw.kr(rate), -1, 1, lo, hi ) };);
	0.1.wait;
	Ndef(\grainy1).map(\rate, Ndef(\lfExp0));

	//modulate grain dur
	Ndef(\lfNoise1,  { |rate=0.43 lo= 0.06 hi=0.3|  LFNoise0.kr(rate).range(lo, hi)  });
	0.1.wait;
	Ndef(\grainy1).map(\dur, Ndef(\lfNoise1));

	//distortion
	Ndef(\dist).copy(\dist0);
	Ndef(\dist0).set( \in, Ndef(\grainy1).bus.index,  \drive, 0.9,  \type, 2,  \amp, 0.21);
	0.1.wait;
	~src2_2 = Ndef(\dist0);


	//Type
	~src3_0 = Ndef(\type);
	Ndef(\icy).copy(\icy0);
	0.1.wait;
	Ndef(\icy0).set(\buf, b[\type], \rate, 0.99998, \amp, 0.2);

	~src3_1 = Ndef(\icy0);

	//modulate scrub rate
	Ndef(\lfTri0,  { | rate=0.007 lo= 0.999998 hi=0.5|  LFTri.kr(rate).range(lo, hi)  });
	0.1.wait;
	Ndef(\icy0).map(\rate,Ndef(\lfTri0));

	//gh
	Ndef(\gh).copy(\gh1);
	0.1.wait;
	Ndef(\gh1).set(\in, Ndef(\icy0).bus.index, \del, 1.5, \dmp, 0.2, \sz, 1.3, \dif, 0.2, \fb, 0.8, \amp, 0.6);
	~src3_2 = Ndef(\gh1);
	//modulate delay rate
	Ndef(\lfSin4,  { |rate=0.013 lo= 0.01 hi=1.14|  SinOsc.kr(rate).range(lo, hi) });
	0.1.wait;
	Ndef(\gh1).map(\del, Ndef(\lfSin4));
	//modulate diff
	Ndef(\lfTRand4,  { | rate=0.3 lo=0.1 hi=0.91 | TRand.kr( lo, hi, Dust.kr(rate) ) });
	0.1.wait;
	Ndef(\gh1).map(\dif, Ndef(\lfTRand4));

	//Accordian
	~src4_0 = Ndef(\acc);
	Ndef(\icy).copy(\icy1);
	0.1.wait;
	Ndef(\icy1).set(\buf, b[\acc], \rate, 0.97, \amp, 0.14);

	~src4_1 = Ndef(\icy1);

	//Saw
	~src5_0 = Ndef(\saw);
	Ndef(\icy).copy(\icy2);
	0.1.wait;
	Ndef(\icy2).set(\buf, b[\saw], \rate, 0.97, \amp, 0.07, \pitchshift, 1.5);
	Ndef(\lfGaussRand2,   {|rate=0.04 lo=1.2 hi=1.8| TGaussRand.kr( lo, hi, Dust.kr(rate) )});
	0.1.wait;
	Ndef(\icy2).map(\pitchshift, Ndef(\lfGaussRand2) );

	~src5_1 = Ndef(\icy2);

	Ndef(\lp0, {|freq=1000 rq=1 amp=1| {RLPF.ar( Ndef(\icy2), freq, rq)*amp}});
	0.1.wait;
	Ndef(\lp0).set(\freq, 1000, \rq, 0.03);
	Ndef(\lfSaw6,  { |rate=0.003 lo= 500 hi=1000|  LFSaw.kr(rate).range(lo, hi)  });
	0.1.wait;
	Ndef(\lp0).map(\freq, Ndef(\lfSaw6));

	Ndef(\lp1, {|freq=1000 rq=1 amp=1| {RLPF.ar( Ndef(\icy2), freq, rq)*amp}});
	0.1.wait;
	Ndef(\lp1).set(\freq, 1000, \rq, 0.04);
	Ndef(\lfSaw7,  { |rate=0.0031 lo= 477 hi=981|  LFSaw.kr(rate).range(lo, hi)  });
	0.1.wait;
	Ndef(\lp1).map(\freq, Ndef(\lfSaw7));

	Ndef(\lp2, {|freq=1000 rq=1 amp=1| {RLPF.ar( Ndef(\icy2), freq, rq)*amp}});
	0.1.wait;
	Ndef(\lp2).set(\freq, 1000, \rq, 0.028);
	Ndef(\lfSaw8,  { |rate=0.004 lo= 533 hi=823|  LFSaw.kr(rate).range(lo, hi)  });
	0.1.wait;
	Ndef(\lp2).map(\freq, Ndef(\lfSaw8));

	~src5_2 = ( Ndef(\lp0)+(Ndef(\icy2)*1.1)+Ndef(\lp1)+Ndef(\lp2) ) * 0.5;

})

(//1)
s.options.memSize = (8192*20);
s.options.numOutputBusChannels = 8;
s.boot;
)
(//2)///////////////////////////////
p = ProxySpace.push(s);
///////////////////////////////////
)


~src0_0; //musicbox random speed
~src0_1; //musicbox through greyhole

~src1_0; //speeding up bowl
~src1_1; //bowl grainulated

~src2_0; //aeolian
~src2_1; //aeolian grainulated
~src2_2; //aeolian distortion

~src3_0; //type
~src3_1; //type freeze
~src3_2; //type gh

~src4_0; //acc
~src4_1; //acc freeze

~src5_0; //saw
~src5_1; //freeze
~src5_2; //pass filter

Server.default.makeGui;
s.meter;

Ndef(\bowl).copy(\bowl2);

Ndef(\bowl2).set(\rate, 0.1);
~s6 = Ndef(\bowl2)*1.2;
~s6 = Ndef(\bowl2);

~o1 = Ndef(\bowl2);
~o1 = nil;
~s6 = nil;

Ndef(\mubox).copy(\mubox2);
Ndef(\mubox2).set(\rate, 0.1);
~o0 = Ndef(\mubox2);
~o0 = nil;
Ndef(\aeolian).copy(\aeolian2);
Ndef(\aeolian2).set(\rate, 0.3);
~o2 = Ndef(\aeolian2);
~o2 = nil;


Ndef(\acc).copy(\acc2);
Ndef(\acc2).set(\rate, 0.2);
~o3 = Ndef(\acc2);
~o3 = nil;

~t0 = ~src0_1*Ndef(\env0);
~s0 = ~t0;
~t1 = ~src1_1*Ndef(\env1);
~s1 = ~t1;
~t2 = ~src2_2*Ndef(\env2);
~s2 = ~t2;
~t3 = ~src3_2*Ndef(\env3);
~s3 = ~t3;
~t4 = ~src4_1*Ndef(\env4);
~s4 = ~t4;
~t5 = ~src5_2*Ndef(\env5);
~s5 = ~t5;

~s0.fadeTime =2;
~s1.fadeTime =2;
~s2.fadeTime =2;
~s3.fadeTime =2;
~s4.fadeTime =2;
~s5.fadeTime =2;
~s6.fadeTime =2;
~s7.fadeTime =2;

~s0=nil;
~s1=nil;
~s2=nil;
~s3=nil;
~s4=nil;
~s5=nil;
~s6=nil;
~s7=nil;

~o0=nil;
~o1=nil;
~o2=nil;

~o3=nil;


~o0 = ~src1_1;
~o0 = nil
~s3 = ~src1_1;

Ndef(\pn0, { PanAz.ar( 8, In.ar(~src1_1.bus.index)*17, SinOsc.kr(0.1), 1, 1) } )
~o0 = Ndef(\pn0)



~o0 = nil
Ndef(\pan0).set(\ibs,~src1_1.bus.index, \rate, 0.011494252873563);
~o0 = Ndef(\panr0);
Ndef(\pan0).set(\rate, 0.5);

Ndef(\ptst

Ndef(\panr0, { arg rate=0.1,  ibs= ~src1_1.bus.index; var pn = SinOsc.kr(rate); {PanAz.ar(8, In.ar(ibs), -1, 1, 1)} } );

Ndef(\sawsaw0, {|rate=0.01111111| LFSaw.kr(rate).range(0, 1)});
~o6 = ~src5_2*Ndef(\sawsaw0)*0.5;

Ndef(\sawsaw1, {|rate=0.02111111| LFSaw.kr(rate).range(0, 1)});
~o7 = ~src3_2*Ndef(\sawsaw1)*0.8;
Ndef(\sawsaw2, {|rate=0.00311111| LFSaw.kr(rate).range(0, 1)});
~o8 = ~src1_1*Ndef(\sawsaw2)*0.5;

~out.fadeTime = 75;
~out = nil



	Ndef(\tp, {Impulse.ar(2)} );
	Ndef.ar(\tp, 8);
	~o0 = Ndef(\tp)
	~o0 = 0
	p = ProxySpace.push(s);
	s.options.numOutputBusChannels = 8;

	Ndef(\fd, { PanAz.ar( 8, Impulse.ar(2)*17, SinOsc.kr(0.1).range(0, 2), 1, 1) } )




	Ndef(\tpp, { |pos=0.5| var rr = SinOsc.ar(0.1); PanAz.ar(8, SinOsc.ar()*12, rr, 1, 1) }).play;
	~o0 = Ndef(\tpp)

	Ndef(\tpp).set(\pos, );

