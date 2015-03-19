//
//  HCMGate.h
//  CPP
//
//  Copyright (c) 2015 Harry Cheung. All rights reserved.
//

#ifndef HCMGATE_H
#define HCMGATE_H

#include "HCMPoint.h"

class HCMGate {
private:
  HCMPoint leftPoint, rightPoint;
public:
  enum Type { START, START_FINISH, FINISH, SPLIT };
  Type gateType;
  int splitNumber;
  HCMPoint location;
  
  HCMGate(Type type, int splitNumber, double latitude, double longitude, double bearing);
  
  bool crossed(HCMPoint start, HCMPoint destination, HCMPoint &cross);
};

#endif