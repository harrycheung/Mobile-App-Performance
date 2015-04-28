//
//  HCMPhysics.h
//  CPP
//
//  Copyright (c) 2015 Harry Cheung. All rights reserved.
//

#ifndef HCMPHYSICS_H
#define HCMPHYSICS_H

class HCMPhysics {
public:
  // x = vt + 1/2att
  static double distance(double velocity, double acceleration, double time);

  // t = (-v + sqrt(2vvax)) / a (quadratic)
  static double time(double distance, double velocity, double acceleration);

};

#endif