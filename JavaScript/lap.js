'use strict';

//
// Copyright (c) 2015 Harry Cheung
//

function Lap(session, track, startTime, lapNumber) {
  this.session = session;
  this.track = track;
  this.startTime = startTime;
  this.lapNumber = lapNumber;
  this.points = [];
  this.duration = 0;
  this.distance = 0;
  this.valid = false;
  this.outLap = lapNumber === 0;
  this.splits = [];
  var size = track.numSplits();
  while (size--) {
    this.splits.push(0);
  }
}

Lap.prototype.add = function (point) {
  this.duration = point.lapTime;
  this.distance = point.lapDistance;
  this.points.push(point);
};

if (typeof exports !== 'undefined' && typeof module !== 'undefined' && module.exports) {
  exports = module.exports = Lap;
}
