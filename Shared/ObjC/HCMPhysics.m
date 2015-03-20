//
//  HCMPhysics.m
//  ObjC
//
//  Created by harry on 2/27/15.
//  Copyright (c) 2015 Harry Cheung. All rights reserved.
//

#import "HCMPhysics.h"
#import <math.h>

@implementation HCMPhysics

// x = vt + 1/2att
+ (double)distanceFromVelocity:(double)velocity
                  acceleration:(double)acceleration
                          time:(double)time {
  return velocity * time + (acceleration * time * time) / 2;
}

// t = (-v + sqrt(2vvax)) / a (quadratic)
+ (double)timeFromDistance:(double)distance
                  velocity:(double)velocity
              acceleration:(double)acceleration {
  if (acceleration == 0) {
    return distance / velocity;
  } else {
    return (-velocity + sqrt(velocity * velocity + 2 * acceleration * distance)) / acceleration;
  }
}

@end
