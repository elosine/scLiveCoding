(//1)
s.options.memSize = (8192*30);
s.options.numOutputBusChannels = 8;
s.boot;
)
(//2)///////////////////////////////
p = ProxySpace.push(s);
///////////////////////////////////
)

(
fork{
    ~o0.ar(2); ~o1.ar(2);
    ~os3.ar(2); ~o4.ar(2); ~o5.ar(2); ~o6.ar(2); ~o7.ar(2); ~o8.ar(2); ~o9.ar(2);
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
        var dur = TChoose.kr( Dust.kr( TRand.kr( (1/3.2), 3, Dust.kr( (1/8.5) ) ) ), [0.03, 0.123, 0.54, 1.07, 3.4, 0.21, 0.064, 0.31, 0.85] );
        var atk = TChoose.kr( Dust.kr( TRand.kr( (1/4.7), 1, Dust.kr( (1/6.2) ) ) ), [0.01, 0.11, 0.47, 0.03, 0.012, 0.05, 0.22] );
        var rel = TChoose.kr( Dust.kr( TRand.kr( (1/2.1), 3.6, Dust.kr( (1/3.16) ) ) ), [0.03, 0.092, 0.7, 0.041, 0.13, 0.048, 0.22] );
        var crv = TChoose.kr( Dust.kr( TRand.kr( (1/7.1), (1/4.21), Dust.kr( (1/9.62) ) ) ), [-4, 4.4, -6, 5.8, 0, -12] );
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


    //Record Mouse

	Ndef(\recms,  { | buf | RecordBuf.kr( MouseX.kr(lag:0.01), buf, loop:0, doneAction:2) });

	Ndef(\playkrbuf, { | buf rate=1 loop=1 | PlayBuf.kr(1, buf, rate, loop:loop) });

})
~o0 = Ndef(\rocks);

Ndef(\env0).set(  \amp, 1,  \cycdurminutes, 10, \cyclo, 42.0, \cychi, 0.2, \waitdurrandrange, 0);

Ndef(\env1).set( \amp, 1,  \cycdurminutes, 9.3, \cyclo, 28.0, \cychi, 0.5, \waitdurrandrange, 3);

Ndef(\env1).set( \amp, 1,  \cycdurminutes, 9.3, \cyclo, 28.0, \cychi, 0.5, \waitdurrandrange, 3);


~o0 = Ndef(\env0)*Ndef(\rocks);
~o1 = Ndef(\env1)*Ndef(\mubox);


k=s.sampleRate/s.options.blockSize;
b = Buffer.alloc(s, k*60);
Ndef(\recms);
~rm0.
make spatializaters

make 'sources' combo of samples and fx have this modulatable by lfos and semi-accessable to user
make some fixed media sources in logic & supercollider and have other modulations for these

Ndef(\mts, {|mul=1| (MouseY.kr()*mul).poll});



~o0 = Ndef(\mubox);

Ndef(\msy, {|lo=0 hi=1| MouseY.kr(lo, hi, lag:0.01) } );
Ndef(\msy).set(\lo, 0, \hi, 5);

Ndef(\mubox).map(\rate, Ndef(\msy));

k=s.sampleRate/s.options.blockSize;
b = Buffer.alloc(s, k*(3.2*60) );

Ndef(\recms,  { | buf | RecordBuf.kr( MouseX.kr(lag:0.01).poll, b, loop:0, doneAction:2) });

Ndef(\playkrbuf, { | buf rate=1 loop=1 lo=0 hi=5 | var mul = hi-lo; var add=lo; PlayBuf.kr(1, b, rate, loop:loop).poll });

Ndef(\mubox).map(\rate, Ndef(\playkrbuf) );

