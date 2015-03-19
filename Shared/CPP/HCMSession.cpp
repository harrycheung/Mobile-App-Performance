//
//  HCMSession.m
//  CPP
//
//  Copyright (c) 2015 Harry Cheung. All rights reserved.
//

#include "HCMSession.h"

HCMSession::HCMSession(HCMTrack *track, double startTime) {
  this->track = track;
  this->startTime = startTime;
  this->duration = 0;
  this->bestLap = NULL;
}

HCMSession::~HCMSession() {
  for (std::vector<HCMLap *>::iterator it = laps.begin(); it != laps.end(); ++it) {
    delete *it;
  }
}