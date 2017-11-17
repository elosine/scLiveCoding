~o0 = ~type
~bowl = \playSamp; ~bowl.set(\buf, b[\bowl]);
~bowl  ~muBox  ~saw  ~aeolian  ~bamboo  ~pans  ~glass  ~eGtr  ~post  ~sitar  ~squeek  ~rocks  ~type  ~match

~e1.set(\rate, 2.5, \atk, 0.03, \sus, 0.07, \rel, 0.05, \crv, 0,  \type, 0); //reg atk=0.03, sus=dur, rel=0.05, crv=0
~e1.set(\rate, 5.5, \atk, 0.01, \sus, 0, \rel, 0.1, \crv, -8,  \type, 0); //perc atk=0.01, sus=0, rel=dur, crv=-4
~e1.set(\rate, 3, \atk, 0.6, \sus, 0, \rel, 0.01, \crv, 10,  \type, 0); //backwards atk=dur, sus=0, rel=0.01, crv=10

~fx1 = \gh
~fx1.set(\in, ~bamboo.bus.index);
~fx1.set(\del, 0.31, \dmp, 0.0, \sz, 0.7, \fb, 0.5, \dif, 0.7);

~p1 = \pan2
~p1.set(\in, ~e1.bus.index);
~p1.set(\pos, -1)

~src2 = \icy
~src2.set(\buf, b[\muBox], \rate, 0.99, \pitchShift, 2);

~rm = \rm
~rm.set(\in, ~bowl.bus.index, \mix, 0.5, \inamp, 10, \amp, 0.5, \fb, 1);

~fx3 = \mGrain
~fx3.set(\in, ~acc.bus.index, \sr, 5000, \br, 12, \rez, 0.5, \gdur1, 0.1, \grdur2, 0.03, \grate1, 5, \grate2, 2, \s0, 0, \s1, 1);

~st1 = \stereo
~st1.set(\in, ~bowl.bus.index)

~d1 = \drone1
~d1.set(\pch, 50, \mul, 1, \rate, 0.05, \dlo, 0.97, \dhi, 1.3)

~n1 = \noise;
~n1.set(\amp, 0.2);

~i1 = \impulses;
~i1.set(\type, 0, \rate, 2, \amp, 1);

~lfSin.set(\rate, 0.01, \lo, -5.5, \hi, 5.5);
~lfGaussRand ~lfSaw ~lfTri ~lfTRand ~lfExp ~lfNoise