//
//  HCMLap.m
//  CPP
//
//  Copyright (c) 2015 Harry Cheung. All rights reserved.
//

#include "HCMLap.h"

HCMLap::HCMLap(HCMSession *session, HCMTrack *track, double startTime, int lapNumber) {
  this->session = session;
  this->track = track;
  this->startTime = startTime;
  this->lapNumber = lapNumber;
  splits = new double[track->gates->size()];
  valid = false;
  duration = 0;
  distance = 0;
}

void HCMLap::add(HCMPoint point) {
  duration = point.lapTime;
  distance = point.lapDistance;
  points.push_back(point);
}

