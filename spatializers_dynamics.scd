p = ProxySpace.push(s);


(
Ndef(\appear,  { | ibs amp=1 cycrate=(1/(7*60)) cyclo=42 cychi=0.2 waitdurrandrange=0|
	var trig, twaitdur=1, env, waitcyc;

	var envtype = TIRand.kr( 0, 3, Dust.kr( TRand.kr( (1/5.7), 2, Dust.kr( (1/7) ) ) ) );
	var dur = TChoose.kr( Dust.kr( TRand.kr( (1/3.2), 3, Dust.kr( (1/8.5) ) ) ), [0.03, 0.123, 0.54, 1.07, 3.4, 0.21, 0.064, 0.31, 0.85] );
	var atk = TChoose.kr( Dust.kr( TRand.kr( (1/4.7), 1, Dust.kr( (1/6.2) ) ) ), [0.01, 0.11, 0.47, 0.03, 0.012, 0.05, 0.22] );
	var rel = TChoose.kr( Dust.kr( TRand.kr( (1/2.1), 3.6, Dust.kr( (1/3.16) ) ) ), [0.03, 0.092, 0.7, 0.041, 0.13, 0.048, 0.22] );
	var crv = TChoose.kr( Dust.kr( TRand.kr( (1/7.1), (1/4.21), Dust.kr( (1/9.62) ) ) ), [-4, 4.4, -6, 5.8, 0, -12] );
	var sus = TChoose.kr( Dust.kr( TRand.kr( (1/8.1), (1/1.4), Dust.kr( (1/3.22) ) ) ), [0.92, 4.72, 1.48, 0.061, 0.87, 3.92] );
	/*var envshape = Select.kr( envtype, [
		Env.sine(dur),
		Env.perc(atk, rel, 1, crv),
		Env.triangle(dur),
		Env.linen(atk, sus, rel, 1, crv)
	] );*/


	var envshape =
	switch( envtype,
		0, {Env.sine(dur)}
	);


	trig = TDelay.kr( Impulse.kr( (cyclo-(cyclo/2) ) ), twaitdur );
	waitcyc = LFSaw.kr(cycrate, 1).range( cyclo, cychi);
	twaitdur = TRand.kr(  waitcyc, waitcyc+waitdurrandrange, trig);
	{ env = EnvGen.ar( envshape, trig).poll };
});

)


Ndef(\playSamp).copy(\bowl);