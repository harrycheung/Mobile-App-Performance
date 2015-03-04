//
//  HCMPoint.m
//  ObjC
//
//  Created by harry on 2/27/15.
//  Copyright (c) 2015 Harry Cheung. All rights reserved.
//

#import "HCMPoint.h"

@implementation HCMPoint

static double RADIUS = 6371000;

+ (double)toRadians:(double)value {
  return value * M_PI / 180.0;
}

+ (double)toDegrees:(double)value {
  return value * 180.0 / M_PI;
}

+ (double)roundValue:(double)value {
  return round(value * 1000000.0) / 1000000.0;
}

- (id)initWithLatitude:(double)latitude
             longitude:(double)longitude
             inRadians:(BOOL)inRadians {
  self = [super init];
  if (self) {
    if (inRadians) {
      self->latitude  = latitude;
      self->longitude = longitude;
    } else {
      self->latitude  = [HCMPoint toRadians:latitude];
      self->longitude = [HCMPoint toRadians:longitude];
    }
    self->speed        = 0;
    self->bearing      = 0;
    self->hAccuracy    = 0;
    self->vAccuracy    = 0;
    self->timestamp    = 0;
    self->lapDistance  = 0;
    self->lapTime      = 0;
    self->splitTime    = 0;
    self->acceleration = 0;

  }
  return self;
}

- (id)initWithLatitude:(double)latitude
             longitude:(double)longitude {
  return [self initWithLatitude:latitude longitude:longitude inRadians:FALSE];
}

- (id)initWithLatitude:(double)latitude
             longitude:(double)longitude
               bearing:(double)bearing {
  self = [self initWithLatitude:latitude longitude:longitude inRadians:FALSE];
  self->bearing = bearing;
  return self;
}

- (id)initWithLatitude:(double)latitude
             longitude:(double)longitude
                 speed:(double)speed
               bearing:(double)bearing
    horizontalAccuracy:(double)horizontalAccuracy
      verticalAccuracy:(double)verticalAccuracy
             timestamp:(double)timestamp {
  self = [self initWithLatitude:latitude longitude:longitude inRadians:FALSE];
  self->speed     = speed;
  self->bearing   = bearing;
  self->hAccuracy = horizontalAccuracy;
  self->vAccuracy = verticalAccuracy;
  self->timestamp = timestamp;
  return self;
}

- (void)setLapTimeWithStartTime:(double)startTime
                 splitStartTime:(double)splitStartTime {
  lapTime = timestamp - startTime;
  splitTime = timestamp - splitStartTime;
}

- (double)latitudeDegrees {
  return [HCMPoint roundValue:[HCMPoint toDegrees:latitude]];
}

- (double)longitudeDegrees {
  return [HCMPoint roundValue:[HCMPoint toDegrees:longitude]];
}

- (double)speed {
  return self->speed;
}

- (double)bearing {
  return self->bearing;
}

- (double)hAccuracy {
  return self->hAccuracy;
}

- (double)vAccuracy {
  return self->vAccuracy;
}

- (HCMPoint*)subtractWithPoint:(HCMPoint*)point {
  return [[[HCMPoint alloc] initWithLatitude:latitude - point->latitude
                                   longitude:longitude - point->longitude
                                   inRadians:TRUE] autorelease];
}

- (double)bearingToPoint:(HCMPoint*)point inRadians:(BOOL)inRadians {
  double φ1 = latitude;
  double φ2 = point->latitude;
  double Δλ = point->longitude - longitude;
  
  double y = sin(Δλ) * cos(φ2);
  double x = cos(φ1) * sin(φ2) - sin(φ1) * cos(φ2) * cos(Δλ);
  double θ = atan2(y, x);
  
  if (inRadians) {
    return [HCMPoint roundValue:fmod(θ + 2 * M_PI, M_PI)];
  } else {
    return [HCMPoint roundValue:fmod([HCMPoint toDegrees:θ] + 2 * 360, 360)];
  }
}

- (double)bearingToPoint:(HCMPoint*)point {
  return [self bearingToPoint:point inRadians:FALSE];
}

- (HCMPoint*)destinationWithBearing:(double)bearing distance:(double)distance {
  double θ  = [HCMPoint toRadians:bearing];
  double δ  = distance / RADIUS;
  double φ1 = latitude;
  double λ1 = longitude;
  double φ2 = asin(sin(φ1) * cos(δ) + cos(φ1) * sin(δ) * cos(θ));
  double λ2 = λ1 + atan2(sin(θ) * sin(δ) * cos(φ1), cos(δ) - sin(φ1) * sin(φ2));
  λ2 = fmod(λ2 + 3.0 * M_PI, 2.0 * M_PI) - M_PI; // normalise to -180..+180
  
  return [[[HCMPoint alloc] initWithLatitude:φ2 longitude:λ2 inRadians:TRUE] autorelease];
}

- (double)distanceToPoint:(HCMPoint*)point {
  double φ1 = latitude;
  double λ1 = longitude;
  double φ2 = point->latitude;
  double λ2 = point->longitude;
  double Δφ = φ2 - φ1;
  double Δλ = λ2 - λ1;
  
  double a = sin(Δφ / 2) * sin(Δφ / 2) + cos(φ1) * cos(φ2) * sin(Δλ / 2) * sin(Δλ / 2);
  
  return RADIUS * 2 * atan2(sqrt(a), sqrt(1 - a));
}

+ (HCMPoint*)intersectSimpleWithPoint:(HCMPoint*)p
                            withPoint:(HCMPoint*)p2
                            withPoint:(HCMPoint*)q
                            withPoint:(HCMPoint*)q2 {
  double s1_x = p2->longitude - p->longitude;
  double s1_y = p2->latitude - p->latitude;
  double s2_x = q2->longitude - q->longitude;
  double s2_y = q2->latitude - q->latitude;
  
  double den = -s2_x * s1_y + s1_x * s2_y;
  if (den == 0) { return nil; }
  
  double s = (-s1_y * (p->longitude - q->longitude) + s1_x * (p->latitude - q->latitude)) / den;
  double t = ( s2_x * (p->latitude - q->latitude) - s2_y * (p->longitude - q->longitude)) / den;
  
  if (s >= 0 && s <= 1 && t >= 0 && t <= 1) {
    return [[[HCMPoint alloc] initWithLatitude:p->latitude + (t * s1_y)
                                     longitude:p->longitude + (t * s1_x)
                                     inRadians:TRUE] autorelease];
  }
  
  return nil;  
}

@end
