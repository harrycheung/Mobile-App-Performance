'use strict';

//
// Copyright (c) 2015 Harry Cheung
//

if (typeof require !== 'undefined') {
	var Point = require('point');
	var Lap = require('lap');
	var Session = require('session');
}

function SessionManager() {}

SessionManager.instance_ = null;
SessionManager.instance = function () {
	if (SessionManager.instance_ == null) {
		SessionManager.instance_ = new SessionManager();
	}
	return SessionManager.instance_;
};

SessionManager.prototype.startSession = function (track) {
	if (this.session == null) {
		this.track = track;
		this.session = new Session(this.track);
		this.currentLap = new Lap(this.session, this.track, this.session.startTime, 0);
		this.session.laps.push(this.currentLap);
		var size = track.numSplits();
		this.splits = [];
		while (size--) {
			this.splits.push(0);
		}
		size = track.numSplits();
		this.splitGaps = [];
		while (size--) {
			this.splitGaps.push(-1);
		}
		this.splitStartTime = this.session.startTime;
		this.splitNumber = 0;
		this.currentSplit = 0;
		this.lapNumber = 0;
		this.gap = 0;
		this.bestIndex = 0;
		this.nextGate = track.start;
	}
};

SessionManager.prototype.endSession = function () {
	this.session = null;
	this.currentLap = null;
	this.bestLap = null;
};

SessionManager.prototype.gps = function (latitude, longitude, speed, bearing,
	horizontalAccuracy, verticalAccuracy, timestamp) {
	var point = new Point(latitude, longitude, false, speed, bearing, horizontalAccuracy,
		verticalAccuracy, timestamp);
	if (this.lastPoint != null) {
		var cross = this.nextGate.crossed(this.lastPoint, point);
		if (cross != null) {
			this.currentLap.add(cross);
			this.currentLap.splits[this.currentSplit] = cross.splitTime;
			switch (this.nextGate.type) {
				case 'START_FINISH':
				case 'FINISH':
					if (this.currentLap.points[0].generated) {
						this.currentLap.valid = true;
						if (this.bestLap == null || this.currentLap.duration < this.bestLap.duration) {
							this.bestLap = this.currentLap;
						}
					}
					break;
				case 'START':
					this.lapNumber++;
					this.currentLap = new Lap(this.session, this.track, cross.timestamp, this.lapNumber);
					this.lastPoint = new Point(
						cross.latitudeDegrees(),
						cross.longitudeDegrees(),
						false,
						cross.speed,
						cross.bearing,
						cross.hAccuracy,
						cross.vAccuracy,
						cross.timestamp);
					this.lastPoint.lapDistance = 0;
					this.lastPoint.lapTime = 0;
					this.lastPoint.generated = true;
					this.currentLap.add(this.lastPoint);
					this.session.laps.push(this.currentLap);
					this.gap = 0;
					var size = this.splitGaps.length;
					while (size--) {
						this.splitGaps[size - 1] = 0;
					}
					this.bestIndex = 0;
					this.currentSplit = 0;
					break;
				case 'SPLIT':
					if (this.bestLap != null) {
						this.splitGaps[this.currentSplit] = this.currentLap.splits[this.currentSplit] - this.bestLap.splits[this.currentSplit];
					}
					this.currentSplit++;
			}
			this.splitStartTime = cross.timestamp;
			this.nextGate = this.track.gates[this.currentSplit];
		}
		if (this.bestLap != null && this.bestIndex < this.bestLap.points.count) {
			while (this.bestIndex < this.bestLap.points.count) {
				var refPoint = this.bestLap.points[this.bestIndex];
				if (refPoint.lapDistance > this.currentLap.distance) {
					var lastRefPoint = this.bestLap.points[this.bestIndex - 1];
					var distanceToLastRefPoint = this.currentLap.distance - lastRefPoint.lapDistance;
					if (distanceToLastRefPoint > 0) {
						var sinceLastRefPoint = distanceToLastRefPoint / point.speed;
						this.gap = point.lapTime - sinceLastRefPoint - lastRefPoint.lapTime;
						this.splitGaps[this.splitNumber] = point.splitTime - sinceLastRefPoint - lastRefPoint.splitTime;
					}
					break;
				}
				this.bestIndex++;
			}
		}
		point.lapDistance = this.lastPoint.lapDistance + this.lastPoint.distanceTo(point);
		point.setLapTime(this.currentLap.startTime, this.splitStartTime);
	}
	this.currentLap.add(point);
	this.lastPoint = point;
};

if (typeof exports !== 'undefined' && typeof module !== 'undefined' && module.exports) {
	exports = module.exports = SessionManager;
}
