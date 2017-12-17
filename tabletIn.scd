x = Bus.control(s);
y = Bus.control(s);
p = Bus.control(s);

OSCdef(\tab, {|msg|
	var xv = msg[1].asFloat;
	var yv = msg[2].asFloat;
	var pv = msg[3].asFloat;
	msg.postln;

	x.setSynchronous(xv);
	y.setSynchronous(yv);
	p.setSynchronous(pv);
}, "/tab");


x.getSynchronous;
y.getSynchronous;
p.getSynchronous; 