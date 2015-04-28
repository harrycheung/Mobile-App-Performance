//
//  HCMPoint.h
//  CPP
//
//  Copyright (c) 2015 Harry Cheung. All rights reserved.
//

#ifndef HCMPOINT_H
#define HCMPOINT_H

class HCMPoint {
public:
  double latitude;
  double longitude;
  double speed;
  double bearing;
  double hAccuracy;
  double vAccuracy;
  double timestamp;
  double lapDistance;
  double lapTime;
  double splitTime;
  double acceleration;
  bool generated;
  
  HCMPoint(double latitude = 0, double longitude = 0, bool inRadians = false,
           double speed = 0, double bearing = 0, double horizontalAccuracy = 0,
           double verticalAccuracy = 0, double timestamp = 0);
  
  void setLapTime(double startTime, double splitStartTime);
  
  double latitudeDegrees();
  double longitudeDegrees();
  
  HCMPoint subtract(HCMPoint point);
  
  double bearingTo(HCMPoint point, bool inRadians = false);
  
  HCMPoint destination(double bearing, double distance);
  
  double distance(HCMPoint point);
  
  static bool intersectSimple(HCMPoint p, HCMPoint p2, HCMPoint q, HCMPoint q2, HCMPoint &intersection);
};

#endif