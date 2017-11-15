(
s.waitForBoot{fork{
s.options.memSize = 81920;
}}
)
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




