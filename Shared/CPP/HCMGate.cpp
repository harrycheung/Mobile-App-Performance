//
//  HCMGate.m
//  CPP
//
//  Copyright (c) 2015 Harry Cheung. All rights reserved.
//

#include "HCMGate.h"
#include "HCMPhysics.h"

static double LINE_WIDTH = 80.0;
static double BEARING_RANGE = 90.0;

HCMGate::HCMGate(Type gateType, int splitNumber, double latitude, double longitude, double bearing) {
  this->gateType = gateType;
  this->splitNumber = splitNumber;
  location = HCMPoint(latitude, longitude, false, 0, bearing);
  double leftBearing  = bearing - 90 < 0 ? bearing + 270 : bearing - 90;
  double rightBearing = bearing + 90 > 360 ? bearing - 270 : bearing + 90;
  leftPoint  = location.destination(leftBearing, LINE_WIDTH / 2.0);
  rightPoint = location.destination(rightBearing, LINE_WIDTH / 2.0);
}

bool HCMGate::crossed(HCMPoint start, HCMPoint destination, HCMPoint &cross) {
  double pathBearing = start.bearingTo(destination);
  if (pathBearing > (location.bearing - BEARING_RANGE) &&
      pathBearing < (location.bearing + BEARING_RANGE)) {
    if (HCMPoint::intersectSimple(leftPoint, rightPoint, start, destination, cross)) {
      double distance     = start.distance(cross);
      double timeSince    = destination.timestamp - start.timestamp;
      double acceleration = (destination.speed - start.speed) / timeSince;
      double timeCross    = HCMPhysics::time(distance, start.speed, acceleration);
      cross.generated    = true;
      cross.speed        = start.speed + acceleration * timeCross;
      cross.bearing      = start.bearingTo(destination);
      cross.timestamp    = start.timestamp + timeCross;
      cross.lapDistance  = start.lapDistance + distance;
      cross.lapTime      = start.lapTime + timeCross;
      cross.splitTime    = start.splitTime + timeCross;
      return true;
    }
  }
  return false;
}
