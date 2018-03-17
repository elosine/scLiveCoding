s.boot;

//1)///////////////////////////////
p = ProxySpace.push(s);
///////////////////////////////////


( //2 ///////////////////////
fork{
	s.options.memSize = 4000000;

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

	Ndef(\grainy, {|in type=0 rate=1 dur=0.1 pan=0 envbuf= -1 amp=1 | {GrainIn.ar(2, Select.kr( type, [ Dust.kr(rate), Impulse.kr(rate) ] ), dur, In.ar(in), pan, envbuf)*amp}});



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
	arg in, inamp=1, amp=1, mix=0.5, bend=1, lf1f=0.2, fb=1;
	var src, dfreq, hasFreq, damp, mod, rm, lf1;
	src = In.ar(in);
	src = src*inamp;
	# dfreq, hasFreq = Tartini.kr(src);
	damp = Amplitude.kr(src);
	lf1 = LFTri.kr(lf1f)*bend;
	mod = SinOscFB.ar( (dfreq.cpsmidi+lf1).midicps,fb )*damp;
	rm = DiodeRingMod.ar(src*mix, mod*(1-mix));
	{ rm*amp};
});

Ndef(\drone1,  {|pch=50 rate=0.06 dlo=0.97 dhi=1.1 mul=1| var freq= pch.midicps; DFM1.ar(SinOsc.ar([freq,freq*1.01]*mul,0,0.1), (freq*2)*mul, SinOsc.kr(rate).range(dlo, dhi),1,0,0.0003,0.5) });

Ndef(\pan2, {|in=0 pos=0 amp=1| Pan2.ar( In.ar(in), pos )*amp  });

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
Ndef(\lfExp, { |rate=1 lo=0.000000001 hi=1.0| LinExp.kr( LFSaw.kr(rate), -1, 1, lo, hi ) };)
})

//examples
 /////////////////////////////////////////////////////////
Ndef(\gr0).set(\in, Ndef(\acc).bus.index, \type, 0, \rate, 21, \dur, 0.05, \pan, 0, \envbuf, d[3], \amp, 5 );
Ndef(\e0).set(\in, Ndef(\gr0).bus.index, \type, 0, \rate, (1/7), \atk, 0.001,\sus, 0, \rel, 1.2, \crv, -4, \lvl, 1, \amp, 1);
Ndef(\gh).set(\in, Ndef(\e1).bus.index, \del, 0.15, \dmp, 0.2, \sz, 1.3, \dif, 0.2, \fb, 0.8, \amp, 1);
Ndef(\rm).set(\in, Ndef(\e3).bus.index, \inamp, 6, \amp, 1, \mix, 0.2, \bend, 1, \lf1f, 0.2, \fb, 1.0);
Ndef(\drone1).set(\pch, 56, \rate, 15.01, \dlo, 1.1, \dhi, 5.2, \mul, 2);
Ndef(\pan2).set(\in, Ndef(\drone1).bus.index, \pos, -1, \amp, 1);
Ndef(\dist).set(\in, Ndef(\aeolian).bus.index, \drive, 0.7, \type, 0, \amp, 2.8);
Ndef(\icy0).set(\buf, b[\mubox], \amp, 1, \envbuf, d[4], \pitchshift, 1, \ratemin, 15.0, \ratemax, 0.000001, \rate, 0.9998);

Ndef(\lfGaussRand).set(\rate, 1, \lo, 0, \hi, 1);
Ndef(\lfSin).set(\rate, 1, \lo, -1, \hi, 1);
Ndef(\lfSaw).set(\rate, 1, \lo, -1, \hi, 1);
Ndef(\lfTri).set(\rate, 1, \lo, -1, \hi, 1);
Ndef(\lfNoise).set(\rate, 1, \lo, -1, \hi, 1);
Ndef(\lfTIRand).set(\rate, 1, \lo, 0, \hi, 1);
Ndef(\lfExp).set(\rate, 1, \lo, 0.000000001, \hi, 1);

Ndef(\grainy, {|in type=0 rate=1 dur=0.1 pan=0 envbuf= -1 amp=1 | {GrainIn.ar(2, Select.kr( type, [ Dust.kr(rate), Impulse.kr(rate) ] ), dur, In.ar(in), pan, envbuf)*amp}});

////////////////////////////////////////////////////////////////////////////////////////////////
~o0 = Ndef(\acc);
~o0 = Ndef(\gr0);
~o0 = Ndef(\e0);
~o0 = Ndef(\gh0); //////////// <<<<<<
~o0 = nil;
~o0.fadeTime = 1;

Ndef(\grainy).copy(\gr0);
Ndef(\gr0).set(\in, Ndef(\acc).bus.index, \type, 0, \rate, 21, \dur, 0.05, \pan, 0, \envbuf, d[3], \amp, 5 );
Ndef(\env).copy(\e0);
Ndef(\e0).set(\in, Ndef(\gr0).bus.index, \type, 0, \rate, 21, \atk, 0.001,\sus, 0, \rel, 3.2, \crv, -4, \lvl, 1, \amp, 1);
Ndef(\gh).copy(\gh0);
Ndef(\gh0).set(\in, Ndef(\e0).bus.index, \del, 0.25, \dmp, 0.2, \sz, 1.3, \dif, 0.2, \fb, 0.8, \amp, 1);

Ndef(\lfTRand).copy(\lfTRand0);
Ndef(\lfTRand0).set(\rate, 3, \lo, 0.6, \hi, 4);
Ndef(\acc).map(\rate, Ndef(\lfTRand0));

Ndef(\lfNoise).copy(\lfNoise0);
Ndef(\lfNoise0).set(\rate, 1/5, \lo, 0.07, \hi, 0.5);
Ndef(\gh0).map(\del, Ndef(\lfNoise0) );

Ndef(\lfSaw).copy(\lfSaw0);
Ndef(\lfSaw0).set(\rate, 1/9, \lo, 0.1, \hi, 0.9);
Ndef(\gh0).map(\dif, Ndef(\lfSaw0) );

Ndef(\lfSin).copy(\lfSin0);
Ndef(\lfSin0).set(\rate, 1/11, \lo, 0.1, \hi, 0.9);
Ndef(\gh0).map(\fb, Ndef(\lfSin0) );

Ndef(\lfPhasor).copy(\lfPhasor0);
Ndef(\lfPhasor0).set(\dur, 300, \lo, 1/42, \hi, 1/4);
Ndef(\e0).map(\rate, Ndef(\lfPhasor0));

~o0 = Ndef(\acc);
~o0 = Ndef(\gr0);
~o0 = Ndef(\e0);
~o0 = Ndef(\gh0); //////////// <<<<<<
~o0 =nil;
////////////////////////////////////////////////////////
/////////////////////////////////////////////
Ndef(\icy).copy(\icy0);
Ndef(\icy0).set(\buf, b[\mubox], \amp, 0.5, \envbuf, d[4], \pitchshift, 1, \ratemin, 15.0, \ratemax, 0.000001, \rate, 0.9998);


Ndef(\lfNoise).copy(\lfNoise4);
Ndef(\lfNoise4).set(\rate, 3, \lo, 0.8, \hi, 0.9999999999);
Ndef(\icy0).map(\rate, Ndef(\lfNoise4) );
~o1.fadeTime = 2;
~o1 = nil;
~o1 = Ndef(\icy0);
~o1 = Ndef(\e1);

Ndef(\env).copy(\e1);
Ndef(\e1).set(\in, Ndef(\icy0).bus.index, \type, 0, \rate, 1/2, \atk, 0.06,\sus, 0, \rel, 2.2, \crv, -4, \lvl, 1, \amp, 0.6);

Ndef(\lfPhasor).copy(\lfPhasor2);
Ndef(\lfPhasor2,  { | dur=60 lo=(1.0/2.0) hi= (3)| Phasor.ar(0, ( 1.0/(SampleRate.ir*dur) ) * (hi-lo), lo, hi)});

Ndef(\e1).map(\rate, Ndef(\lfPhasor2));

Ndef(\e1).set(\rate, 1/13);


Ndef(\drone1).copy(\drone1_0);
Ndef(\drone1_0).set(\pch, 90, \rate, 13.01, \dlo, 0.1, \dhi, 5.2, \mul, 0.1);
Ndef(\lfSin).copy(\lfSin2);
Ndef(\lfSin2).set(\rate, (1/34), \lo, 63, \hi, 99);

Ndef(\drone1_0).map(\pch, Ndef(\lfSin2));


~o2.fadeTime = 2;
~o2 = nil;
~o2 = Ndef(\drone1_0)
~o2 = Ndef(\e2)
~o2 = Ndef(\dist0)

Ndef(\env).copy(\e2);
Ndef(\e2).set(\in, Ndef(\drone1_0).bus.index, \type, 0, \rate, 1/4, \atk, 0.2,\sus, 1, \rel, 0.5, \crv, -4, \lvl, 1, \amp, 0.1);

Ndef(\dist).copy(\dist0);
Ndef(\dist0).set(\in, Ndef(\drone1_0).bus.index, \drive, 0.9, \type, 2, \amp, 0.4);

Ndef(\icy).copy(\icy2);
Ndef(\icy2).set(\buf, b[\aeolian], \amp, 0.07, \envbuf, d[4], \pitchshift, 0.7, \ratemin, 15.0, \ratemax, 0.000001, \rate, 0.9999);

~o3 = Ndef(\icy2);

Ndef(\lfTRand).copy(\lfTRand2);
Ndef(\lfTRand2).set(\rate, (3), \lo, 0.7, \hi, 2.2);
Ndef(\icy2).map(\pitchshift, Ndef(\lfTRand2));

Ndef(\lfTRand).copy(\lfTRand6);
Ndef(\lfTRand6).set(\rate, (14), \lo, 0.7, \hi, 0.99999999999);
Ndef(\icy2).map(\rate, Ndef(\lfTRand6));


~o4 = Ndef(\glass);
~o4.fadeTime = 2;
~o4 = nil;

Ndef(\glass).set(\rate, 0.1, \amp, 0.3);

Ndef(\lfNoise).copy(\lfNoise2);
Ndef(\lfNoise2).set(\rate, 8, \lo, 0.07, \hi, 0.2);
Ndef(\glass).map(\rate, Ndef(\lfNoise2) );

Ndef(\lfPhasor).copy(\lfPhasor3);
Ndef(\lfPhasor3).set(\dur, 1/11, \lo, 0.1, \hi, 11);
Ndef(\lfNoise2).map(\rate, Ndef(\lfPhasor3));

~o6 = Ndef(\type);
~o6.fadeTime = 2

~o6 = Ndef(\gr5);
~o6 = nil;

~o6 = Ndef(\gh3);

Ndef(\grainy).copy(\gr5);
Ndef(\gr5).set(\in, Ndef(\type).bus.index, \type, 1, \rate, 33, \dur, 0.002, \pan, 0, \envbuf, d[9], \amp, 3 );

Ndef(\type).set(\rate, 7);
Ndef(\gh).copy(\gh3);
Ndef(\gh3).set(\in, Ndef(\gr5).bus.index, \del, 0.15, \dmp, 0.0, \sz, 0.5, \dif, 0.2, \fb, 0.8, \amp, 1);
















Ndef(\icy).copy(\icy0);
Ndef(\icy0).set(\buf, b[\mubox], \amp, 1, \envbuf, d[4], \pitchshift, 1, \ratemin, 15.0, \ratemax, 0.000001, \rate, 0.9998);
Ndef(\env).copy(\e1);
Ndef(\e1).set(\in, Ndef(\icy0).bus.index, \type, 0, \rate, 1/12, \atk, 0.1,\sus, 1.5, \rel, 0.6, \crv, -4, \lvl, 1, \amp, 0.3);

~o1 = Ndef(\e1);
~o1 = Ndef(\icy0);
~o1 = nil;
Ndef(\lfGaussRand).copy(\lfGaussRand0);
Ndef(\lfGaussRand0).set(\rate, 1/3, \lo, 0.99, \hi, 0.9999999);

Ndef(\icy0).map(\rate, Ndef(\lfGaussRand0));

Ndef(\drone1).copy(\drone1_0);
Ndef(\drone1_0).set(\pch, 72, \rate, 15.01, \dlo, 1.1, \dhi, 5.2, \mul, 0.1);

~o2.fadeTime = 2;
~o2 = nil;
~o2 = Ndef(\drone1_0);
~o2 = Ndef(\dist0);
~o2 = Ndef(\gr2);

Ndef(\dist).copy(\dist0);
Ndef(\dist0).set(\in, Ndef(\drone1_0).bus.index, \drive, 0.9, \type, 2, \amp, 0.4);

Ndef(\grainy).copy(\gr2);
Ndef(\gr2).set(\in, Ndef(\dist0).bus.index, \type, 1, \rate, 5, \dur, 0.05, \pan, 0, \envbuf, d[9], \amp, 1 );




'