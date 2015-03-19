//
//  HCMLap.h
//  CPP
//
//  Copyright (c) 2015 Harry Cheung. All rights reserved.
//

#ifndef HCMLAP_H
#define HCMLAP_H

#include "HCMSession.h"
#include "HCMTrack.h"
#include <vector>

class HCMSession;

class HCMLap {
public:
  HCMSession *session;
  HCMTrack *track;
  double duration;
  double distance;
  bool valid;
  double startTime;
  int lapNumber;
  std::vector<HCMPoint> points;
  double *splits;
  
  HCMLap(HCMSession *session, HCMTrack *track, double startTime, int lapNumber);
  
  void add(HCMPoint point);
};

#endif