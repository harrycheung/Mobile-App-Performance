//
//  HCMSession.h
//  CPP
//
//  Copyright (c) 2015 Harry Cheung. All rights reserved.
//

#ifndef HCMSESSION_H
#define HCMSESSION_H

#include "HCMTrack.h"
#include "HCMLap.h"
#include <vector>

class HCMLap;

class HCMSession {
public:
  HCMTrack *track;
  double startTime;
  double duration;
  std::vector<HCMLap *> laps;
  HCMLap *bestLap;
  
  HCMSession(HCMTrack *track, double startTime);
  ~HCMSession();
};

#endif