'use strict';

//
// Copyright (c) 2015 Harry Cheung
//

if (typeof require !== 'undefined') {
	var Physics = require('physics');
	var Point = require('point');
}

var LINE_WIDTH = 80;
var BEARING_RANGE = 90;

function Gate(type, splitNumber, latitude, longitude, bearing) {
	this.type = type;
	this.splitNumber = splitNumber;
	Point.call(this, latitude, longitude, false);
	var leftBearing = bearing - 90 < 0 ? bearing + 270 : bearing - 90;
	var rightBearing = bearing + 90 > 360 ? bearing - 270 : bearing + 90;
	this.leftPoint = Point.prototype.destination.call(this, leftBearing, LINE_WIDTH / 2);
	this.rightPoint = Point.prototype.destination.call(this, rightBearing, LINE_WIDTH / 2);
	this.bearing = bearing;
}
Gate.prototype = Object.create(Point.prototype);

Gate.prototype.crossed = function (start, destination) {
	var pathBearing = start.bearingTo(destination);
	var cross = null;
	if (pathBearing > (this.bearing - BEARING_RANGE) && pathBearing < (this.bearing + BEARING_RANGE)) {
		cross = Point.intersectSimple(this.leftPoint, this.rightPoint, start, destination);
		if (cross !== null) {
			var distance = start.distanceTo(cross);
			var timeSince = destination.timestamp - start.timestamp;
			var acceleration = (destination.speed - start.speed) / timeSince;
			var timeCross = Physics.time(distance, start.speed, acceleration);
			cross.generated = true;
			cross.speed = start.speed + acceleration * timeCross;
			cross.bearing = start.bearingTo(destination);
			cross.timestamp = start.timestamp + timeCross;
			cross.lapDistance = start.lapDistance + distance;
			cross.lapTime = start.lapTime + timeCross;
			cross.splitTime = start.splitTime + timeCross;
		}
	}
	return cross;
};

if (typeof exports !== 'undefined' && typeof module !== 'undefined' && module.exports) {
	exports = module.exports = Gate;
}
