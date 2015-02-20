//
// Copyright (c) 2015 Harry Cheung
//

function Session(track, startTime) {
  this.track = track;
  this.startTime = startTime;
  this.duration = 0;
  this.laps = [];
  this.bestLap = null;
}