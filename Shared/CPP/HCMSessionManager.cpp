//
//  HCMSessionManager.m
//  CPP
//
//  Copyright (c) 2015 Harry Cheung. All rights reserved.
//

#include "HCMSessionManager.h"
#include <iostream>

HCMSessionManager *HCMSessionManager::instance = new HCMSessionManager();

HCMSessionManager::HCMSessionManager() {
  session = NULL;
}

void HCMSessionManager::start(HCMTrack *track, double startTime) {
  if (session == NULL) {
    this->track = track;
    session = new HCMSession(track, startTime);
    currentLap = new HCMLap(session, track, startTime, 0);
    session->laps.push_back(currentLap);
    splits = new double[track->gates->size()];
    splitGaps = new double[track->gates->size()];
    splitStartTime = startTime;
    splitNumber = 0;
    currentSplit = 0;
    lapNumber = 0;
    gap = 0;
    bestIndex = 0;
    nextGate = track->start;
    bestLap = NULL;
  }
}

void HCMSessionManager::end() {
  if (session != NULL) {
    delete session;
    delete [] splits;
    delete [] splitGaps;
    session = NULL;
  }
}

void HCMSessionManager::gps(double latitude, double longitude, double speed, double bearing,
                            double horizontalAccuracy, double verticalAccuracy, double timestamp) {
  HCMPoint point = HCMPoint(latitude, longitude, false, speed, bearing,
                            horizontalAccuracy, verticalAccuracy, timestamp);
  if (currentLap->points.size() != 0) {
    HCMPoint cross = HCMPoint();
    if (nextGate->crossed(lastPoint, point, cross)) {
      currentLap->add(cross);
      currentLap->splits[currentSplit] = cross.splitTime;
      switch (nextGate->gateType) {
        case HCMGate::START_FINISH:
        case HCMGate::FINISH:
          if (currentLap->points[0].generated) {
            currentLap->valid = true;
            if (bestLap == NULL || currentLap->duration < bestLap->duration) {
              bestLap = currentLap;
            }
          }
        case HCMGate::START:
          lapNumber++;
          currentLap =  new HCMLap(session, track, cross.timestamp, lapNumber);
          lastPoint = HCMPoint(cross.latitudeDegrees(), cross.longitudeDegrees(),
                               false, cross.speed, cross.bearing,
                               cross.hAccuracy, cross.vAccuracy, cross.timestamp);
          lastPoint.lapDistance = 0;
          lastPoint.lapTime = 0;
          lastPoint.generated = true;
          currentLap->add(lastPoint);
          session->laps.push_back(currentLap);
          gap = 0;
          for (int i = 0; i < track->gates->size(); i++) {
            splitGaps[i] = 0.0;
          }
          bestIndex = 0;
          currentSplit = 0;
          break;
        case HCMGate::SPLIT:
          if (bestLap != NULL) {
            splitGaps[currentSplit] = currentLap->splits[currentSplit] - bestLap->splits[currentSplit];
          }
          currentSplit++;
      }
      splitStartTime = cross.timestamp;
      nextGate = track->gates->operator[](currentSplit);
    }
    if (bestLap != NULL && bestIndex < bestLap->points.size()) {
      while (bestIndex < bestLap->points.size()) {
        HCMPoint refPoint = bestLap->points[bestIndex];
        if (refPoint.lapDistance > currentLap->distance) {
          HCMPoint lastRefPoint = bestLap->points[bestIndex - 1];
          double distanceToLastRefPoint = currentLap->distance - lastRefPoint.lapDistance;
          if (distanceToLastRefPoint > 0) {
            double sinceLastRefPoint = distanceToLastRefPoint / point.speed;
            gap = point.lapTime - sinceLastRefPoint - lastRefPoint.lapTime;
            splitGaps[currentSplit] = point.splitTime - sinceLastRefPoint - lastRefPoint.splitTime;
          }
          break;
        }
        bestIndex++;
      }
    }
    point.lapDistance = lastPoint.lapDistance + lastPoint.distance(point);
    point.setLapTime(currentLap->startTime, splitStartTime);
  }
  currentLap->add(point);
  lastPoint = point;
}
