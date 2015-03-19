//
//  HCMTrack.h
//  CPP
//
//  Copyright (c) 2015 Harry Cheung. All rights reserved.
//

#ifndef HCMTRACK_H
#define HCMTRACK_H

#include <vector>
#include "HCMGate.h"

class HCMTrack {
public:
  std::vector<HCMGate*> *gates;
  HCMGate *start;
  
  HCMTrack(std::vector<HCMGate*> *gates, HCMGate *start);
  ~HCMTrack();
};

#endif