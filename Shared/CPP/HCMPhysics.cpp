//
//  HCMPhysics.m
//  CPP
//
//  Copyright (c) 2015 Harry Cheung. All rights reserved.
//

#include "HCMPhysics.h"
#include <math.h>

// x = vt + 1/2att
double HCMPhysics::distance(double velocity, double acceleration, double time) {
  return velocity * time + (acceleration * time * time) / 2;
}

// t = (-v + sqrt(2vvax)) / a (quadratic)
double HCMPhysics::time(double distance, double velocity, double acceleration) {
  if (acceleration == 0) {
    return distance / velocity;
  } else {
    return (-velocity + sqrt(velocity * velocity + 2 * acceleration * distance)) / acceleration;
  }
}
