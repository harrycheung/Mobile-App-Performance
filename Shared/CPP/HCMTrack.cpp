//
//  HCMTrack.m
//  CPP
//
//  Copyright (c) 2015 Harry Cheung. All rights reserved.
//

#include "HCMTrack.h"

HCMTrack::HCMTrack(std::vector<HCMGate*> *gates, HCMGate *start) {
  this->gates = gates;
  this->start = start;
}

HCMTrack::~HCMTrack() {
  delete gates;
}