//
//  HCMGate.m
//  ObjC
//
//  Created by harry on 2/27/15.
//  Copyright (c) 2015 Harry Cheung. All rights reserved.
//

#import "HCMGate.h"
#import "HCMPhysics.h"

@interface HCMGate() {

  HCMPoint *leftPoint;
  HCMPoint *rightPoint;
  
}

@end

@implementation HCMGate

static double LINE_WIDTH = 80.0;
static double BEARING_RANGE = 90.0;

- (id)initWithType:(HCMGateType)type
       splitNumber:(int)splitNumber
          latitude:(double)latitude
         longitude:(double)longitude
           bearing:(double)bearing {
  self = [super initWithLatitude:latitude longitude:longitude inRadians:FALSE];
  if (self) {
    self->type = type;
    self->splitNumber = splitNumber;
    double leftBearing  = bearing - 90 < 0 ? bearing + 270 : bearing - 90;
    double rightBearing = bearing + 90 > 360 ? bearing - 270 : bearing + 90;
    leftPoint  = [[super destinationWithBearing:leftBearing distance:LINE_WIDTH / 2.0] retain];
    rightPoint = [[super destinationWithBearing:rightBearing distance:LINE_WIDTH / 2.0] retain];
    self->bearing = bearing;
  }
  return self;
}

- (HCMPoint *)crossedWithStart:(HCMPoint *)start
                   destination:(HCMPoint *)destination {
  double pathBearing = [start bearingToPoint:destination];
  HCMPoint *cross = nil;
  if (pathBearing > (self->bearing - BEARING_RANGE) &&
      pathBearing < (self->bearing + BEARING_RANGE)) {
    cross = [HCMPoint intersectSimpleWithPoint:leftPoint
                                     withPoint:rightPoint
                                     withPoint:start
                                     withPoint:destination];
    if (cross != nil) {
      double distance     = [start distanceToPoint:cross];
      double timeSince    = destination->timestamp - start->timestamp;
      double acceleration = (destination->speed - start->speed) / timeSince;
      double timeCross    = [HCMPhysics timeFromDistance:distance velocity:start->speed acceleration:acceleration];
      cross->generated    = TRUE;
      cross->speed        = start->speed + acceleration * timeCross;
      cross->bearing      = [start bearingToPoint:destination];
      cross->timestamp    = start->timestamp + timeCross;
      cross->lapDistance  = start->lapDistance + distance;
      cross->lapTime      = start->lapTime + timeCross;
      cross->splitTime    = start->splitTime + timeCross;
    }
  }
  return cross;
}

- (void)dealloc {
  [leftPoint release];
  [rightPoint release];
  [super dealloc];
}

@end
