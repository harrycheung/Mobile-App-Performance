//
//  HCMSessionManager.h
//  CPP
//
//  Copyright (c) 2015 Harry Cheung. All rights reserved.
//

#ifndef HCMSESSIONMANAGER_H
#define HCMSESSIONMANAGER_H

#include "HCMSession.h"
#include "HCMLap.h"
#include "HCMPoint.h"
#include "HCMGate.h"

class HCMSessionManager {
public:
  static HCMSessionManager *instance;
  
  HCMSession *session;
  HCMLap *currentLap;
  HCMLap *bestLap;
  HCMPoint lastPoint;
  int bestIndex;
  HCMGate *nextGate;
  int gateIter;
  double *splits;
  double *splitGaps;
  double splitStartTime;
  int splitNumber;
  HCMTrack *track;
  int currentSplit;
  int lapNumber;
  double gap;

  HCMSessionManager();
  void start(HCMTrack *track, double startTime);
  void end();
  void gps(double latitude, double longitude, double speed, double bearing,
           double horizontalAccuracy, double verticalAccuracy, double timestamp);
};

#endif