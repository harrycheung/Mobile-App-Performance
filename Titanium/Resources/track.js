'use strict';

//
//  Copyright (c) 2015 Harry Cheung
//

if (typeof require !== 'undefined') {
	var Gate = require('gate');
}

function Track(json) {
	this.start = null;
	this.gates = [];
	var jsonTrack = json.track;
	var jsonGates = jsonTrack.gates;
	var length = jsonGates.length;
	for (var i = 0; i < length; i++) {
		var jsonGate = jsonGates[i];
		var gate = new Gate(jsonGate.gate_type,
			parseInt(jsonGate.split_number),
			parseFloat(jsonGate.latitude),
			parseFloat(jsonGate.longitude),
			parseFloat(jsonGate.bearing));
		if (gate.type === 'START_FINISH' || gate.type === 'START') {
			this.start = gate;
		}
		this.gates.push(gate);
	}
	this.id = parseInt(jsonTrack.id);
	this.name = jsonTrack.name;
}

Track.prototype.numSplits = function () {
	return this.gates.length;
};

if (typeof exports !== 'undefined' && typeof module !== 'undefined' && module.exports) {
	exports = module.exports = Track;
}
