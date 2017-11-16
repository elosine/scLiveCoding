/*(
s.waitForBoot{fork{*/

s.options.memSize = 81920;

p = ProxySpace.push(s);
~o0.ar(2);
~o1.ar(2);
~o2.ar(2);
~o3.ar(2);
~o4.ar(2);
~o5.ar(2);
~o6.ar(2);
~o7.ar(2);
~o8.ar(2);
~o9.ar(2);
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

	2  - bamboocracking.aiff
	3  - clangingPans.wav
	4  - elecGuitar.wav
	5  - glassbreak
	6  - match
	7  - musicbox
	8  - post
	9  - rocks
	10 - singing bowl
	11 - sitar
	12 - squeakywood
	13 - tablesaw
	14 - typing

b=();
b.add(\accBreath -> c[0]);
b.add(\aeolian -> c[1]);
b.add(\bamboo -> c[2]);
b.add(\pans -> c[3]);
b.add(\eGtr -> c[4]);
b.add(\glass -> c[5]);
b.add(\match -> c[6]);
b.add(\muBox -> c[7]);
b.add(\post -> c[8]);
b.add(\rocks -> c[9]);
b.add(\bowl -> c[10]);
b.add(\sitar -> c[11]);
b.add(\squeek -> c[12]);
b.add(\saw -> c[13]);
b.add(\type -> c[14]);

SynthDef(\playSamp,  { |buf out=0 rate=1 amp=1| Out.ar( out, PlayBuf.ar(1, buf, rate, loop:1)*amp )}).add;


//using synthdefs with jitlib
p= ProxySpace.push(s);			//clear and create new
~out.ar(2);							//new main out proxy
~out.play;							//start monitoring
//send a synthdef to the server as normal
(
SynthDef('jitlibtest', { arg buf=0, out;
	var z;
	z= PlayBuf.ar(1, buf, 1, loop:1);
	Out.ar(out, z);
}).send(s);
)
//and access it later in jitlib like this.  just give the name of the synthdef as a symbol
~accord = \playSamp;
~accord.set(\buf, c[1])
~out = ~accord;
~src.set(\freq, 300);
~src.set(\freq, 200);
~out.stop;





p = ProxySpace.push(s);
(
SynthDef('jitlibtest', {|buf och rate=1 amp=1|
	var z;
	Out.ar(och, PlayBuf.ar(1, buf, rate, loop:1)*amp);
}).send(s);
)
~accord.stop;
~accord = { |buf och=50 rate=1 amp=1| Out.ar( och, PlayBuf.ar(1, buf, rate, loop:1)*amp )};
~accord.bus.index;
~accord = nil;


/*}}
)*/
~pb = s.options.firstPrivateBus;
~path = Document.current.dir ++ "/samples/*";
~b = SoundFile.collectIntoBuffers(~path);
0.1.wait;
//make sure all samples are mono
~b.do{|it ix|
	if(it.numChannels==2, {
		it.loadToFloatArray( action: { |array|
			var a1 = array;
			var newBuf;
			{~b[ix] = Buffer.loadCollection(s, a1.unlace(2).sum*0.5);}.defer;

		});
	});
};
SynthDef(\playSamp,  { |buf och=0 rate=1 amp=1| Out.ar( och, PlayBuf.ar(1, buf, rate, loop:1)*amp )}).add;
SynthDef(\linenEnvD, { |ich och=0, atk=0.01, sus=0.08, rel=0.03 rate=1 amp=1| Out.ar(och, In.ar(ich)*EnvGen.ar(Env.linen(atk, sus, rel), Dust.kr(rate)  ) )}).add;
SynthDef(\linenEnvP, { |ich och=0, atk=0.01, sus=0.08, rel=0.03 rate=1 amp=1| Out.ar(och, In.ar(ich)*EnvGen.ar(Env.linen(atk, sus, rel), Impulse.kr(rate)  ) )}).add;

~eRd = {|synth atk=0.01 sus=0.1 rel=0.08 rate=1 amp=1| var bus = ~pb; ~pb = ~pb+1; synth.set(\och, bus); Synth( \linenEnvD, [\ich, bus, \atk, atk, \sus, sus, \rel, rel, \rate, rate, \amp, amp], synth.nodeID, \addAfter) };

~eRp = {|synth atk=0.01 sus=0.1 rel=0.08 rate=1 amp=1| var bus = ~pb; ~pb = ~pb+1; synth.set(\och, bus); Synth( \linenEnvP, [\ich, bus, \atk, atk, \sus, sus, \rel, rel, \rate, rate, \amp, amp], synth.nodeID, \addAfter) };

//set args for sample playback instance
~sSet = {|synth rate=1 amp=1| synth.set(\rate, rate, \amp, amp)};
//set args for enveloped sample
~eSet = { |synth atk=0.01 sus=0.1 rel=0.01 rate=1 amp=1| synth.set(\atk, atk, \sus, sus, \rel, rel, \rate, rate, \amp, amp)};
//play sample
~sp = { |buf och=0 rate=1 amp=1| Synth(\playSamp, [\buf, ~b[buf], \och, och, \rate, rate, \amp, amp ] )};


//buffer, outChannel, rate, amp
~bowl = ~sp.value(10, rate:0.5);
//synth rate amp
~sSet.value(~bowl, 3.3);
//synth atk sus rel rate amp
~ebowl = ~eRd.value(~bowl, 0.03, 5);
//synth atk sus rel rate amp
~eSet.value(~ebowl, sus:0.02, rate:1);
//synth atk sus rel rate amp
~ebowl2 = ~eRp.value(~bowl, rate: 7);
//synth atk sus rel rate amp
~eSet.value(~ebowl2, 0.01, 0.001, 0.01, 8);

~rs = [3, 4, 5.2, 8, 13, 2];
~rt0 = Routine({ inf.do{ var cc = ~rs.choose; ~eSet.value(~ebowl2, rate:cc); rrand(0.2, 3).wait}}).play;
~rt0.play;

// fx
// lfos
////noise based ones
// space




