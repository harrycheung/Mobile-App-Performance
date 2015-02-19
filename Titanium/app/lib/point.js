/**
 * Copyright (c) 2015 Harry Cheung
 */

if (typeof(Number.prototype.toRadians) === "undefined") {
  Number.prototype.toRadians = function() {
    return this * Math.PI / 180.0;
  };
}

if (typeof(Number.prototype.toDegrees) === "undefined") {
  Number.prototype.toDegrees = function() {
    return this * 180.0 / Math.PI;
  };
}

RADIUS = 6371000;

module.exports = function Point(latitude, longitude, inRadians,
  speed, bearing, horizontalAccuracy, verticalAccuracy, timestamp) {

  inRadians = typeof inRadians !== 'undefined' ? inRadians : false;
  if (inRadians) {
    this.latitude = latitude;
    this.longitude = longitude;
  } else {
    this.latitude = latitude.toRadians();
    this.longitude = longitude.toRadians();
  }

  this.speed = typeof speed !== 'undefined' ? speed : 0.0;
  this.bearing = typeof bearing !== 'undefined' ? speed : 0.0;
  this.hAccuracy = typeof horizontalAccuracy !== 'undefined' ? speed : 0.0;
  this.vAccuracy = typeof verticalAccuracy !== 'undefined' ? speed : 0.0;
  this.timestamp = typeof timestamp !== 'undefined' ? speed : 0.0;
  this.lapDistance = 0.0;
  this.lapTime = 0.0;
  this.splitTime = 0.0;

  function setLapTime(startTime, splitStartTime) {
    lapTime = timestamp - startTime;
    splitTime = timestamp - splitStartTime;
  }

  function roundValue(value) {
    return Math.round(value * 1000000.0) / 1000000.0;
  }

  function latitudeDegrees() {
    return roundValue(latitude.toDegrees());
  }

  function longitudeDegrees() {
    return roundValue(longitude.toDegrees());
  }

  function subtract(point) {
    return new Point(latitude - point.latitude, longitude - point.longitude, true);
  }

  function bearingTo(point, inRadians) {
    var φ1 = latitude;
    var φ2 = point.latitude;
    var Δλ = point.longitude - longitude;

    var y = Math.sin(Δλ) * Math.cos(φ2);
    var x = Math.cos(φ1) * Math.sin(φ2) - Math.sin(φ1) * Math.cos(φ2) * Math.cos(Δλ);
    var θ = Math.atan2(y, x);

    if (inRadians) {
      return roundValue((θ + 2 * Math.PI) % Math.PI);
    } else {
      return roundValue((toDegrees(θ) + 2 * 360) % 360);
    }
  }

  function destination(bearing, distance) {
    var θ = bearing.toRadians();
    var δ = distance / RADIUS;
    var φ1 = latitude;
    var λ1 = longitude;
    var φ2 = Math.aMath.sin(Math.sin(φ1) * Math.cos(δ) + Math.cos(φ1) * Math.sin(δ) * Math.cos(θ));
    var λ2 = λ1 + Math.atan2(Math.sin(θ) * Math.sin(δ) * Math.cos(φ1), Math.cos(δ) - Math.sin(φ1) * Math.sin(φ2));
    λ2 = (λ2 + 3.0 * Math.PI) % (2.0 * Math.PI) - Math.PI; // normalise to -180..+180

    return new Point(φ2, λ2, true);
  }

  function distanceTo(point) {
    var φ1 = latitude;
    var λ1 = longitude;
    var φ2 = point.latitude;
    var λ2 = point.longitude;
    var Δφ = φ2 - φ1;
    var Δλ = λ2 - λ1;

    var a = Math.sin(Δφ / 2) * Math.sin(Δφ / 2) + Math.cos(φ1) * Math.cos(φ2) * Math.sin(Δλ / 2) * Math.sin(Δλ / 2);

    return RADIUS * 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  }

  function intersectSimple(p, p2, q, q2) {
    var s1_x = p2.longitude - p.longitude;
    var s1_y = p2.latitude - p.latitude;
    var s2_x = q2.longitude - q.longitude;
    var s2_y = q2.latitude - q.latitude;

    var den = (-s2_x * s1_y + s1_x * s2_y);
    if (den === 0) {
      return nil;
    }

    var s = (-s1_y * (p.longitude - q.longitude) + s1_x * (p.latitude - q.latitude)) / den;
    var t = (s2_x * (p.latitude - q.latitude) - s2_y * (p.longitude - q.longitude)) / den;

    if (s >= 0 && s <= 1 && t >= 0 && t <= 1) {
      return new Point(p.latitude + (t * s1_y), p.longitude + (t * s1_x), true);
    }

    return nil;
  }

};
