//
//  HCMPoint.m
//  CPP
//
//  Copyright (c) 2015 Harry Cheung. All rights reserved.
//

#include "HCMPoint.h"
#include <math.h>

static double RADIUS = 6371000;

double toRadians(double value) {
  return value * M_PI / 180.0;
}

double toDegrees(double value) {
  return value * 180.0 / M_PI;
}

double roundValue(double value) {
  return round(value * 1000000.0) / 1000000.0;
}

HCMPoint::HCMPoint(double latitude, double longitude, bool inRadians,
                   double speed, double bearing, double horizontalAccuracy,
                   double verticalAccuracy, double timestamp) {
  if (inRadians) {
    this->latitude  = latitude;
    this->longitude = longitude;
  } else {
    this->latitude  = toRadians(latitude);
    this->longitude = toRadians(longitude);
  }
  this->speed        = speed;
  this->bearing      = bearing;
  this->hAccuracy    = horizontalAccuracy;
  this->vAccuracy    = verticalAccuracy;
  this->timestamp    = timestamp;
  this->lapDistance  = 0;
  this->lapTime      = 0;
  this->splitTime    = 0;
  this->acceleration = 0;
  this->generated    = false;
}

void HCMPoint::setLapTime(double startTime, double splitStartTime) {
  lapTime = timestamp - startTime;
  splitTime = timestamp - splitStartTime;
}

double HCMPoint::latitudeDegrees() { return roundValue(toDegrees(latitude)); }
double HCMPoint::longitudeDegrees() { return roundValue(toDegrees(longitude)); }

HCMPoint HCMPoint::subtract(HCMPoint point) {
  return HCMPoint(latitude - point.latitude, longitude - point.longitude, true);
}

double HCMPoint::bearingTo(HCMPoint point, bool inRadians) {
  double lat1 = latitude;
  double lat2 = point.latitude;
  double delta_lon = point.longitude - longitude;
  
  double y = sin(delta_lon) * cos(lat2);
  double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(delta_lon);
  double omega = atan2(y, x);
  
  if (inRadians) {
    return roundValue(fmod(omega + 2 * M_PI, M_PI));
  } else {
    return roundValue(fmod(toDegrees(omega) + 2 * 360, 360));
  }
}

HCMPoint HCMPoint::destination(double bearing, double distance) {
  double omega  = toRadians(bearing);
  double delta  = distance / RADIUS;
  double lat1 = latitude;
  double lon1 = longitude;
  double lat2 = asin(sin(lat1) * cos(delta) + cos(lat1) * sin(delta) * cos(omega));
  double lon2 = lon1 + atan2(sin(omega) * sin(delta) * cos(lat1), cos(delta) - sin(lat1) * sin(lat2));
  lon2 = fmod(lon2 + 3.0 * M_PI, 2.0 * M_PI) - M_PI; // normalise to -180..+180
  
  return HCMPoint(lat2, lon2, true);
  
}

double HCMPoint::distance(HCMPoint point) {
  double lat1 = latitude;
  double lon1 = longitude;
  double lat2 = point.latitude;
  double lon2 = point.longitude;
  double delta_lat = lat2 - lat1;
  double delta_lon = lon2 - lon1;
  
  double a = sin(delta_lat / 2) * sin(delta_lat / 2) + cos(lat1) * cos(lat2) * sin(delta_lon / 2) * sin(delta_lon / 2);
  
  return RADIUS * 2 * atan2(sqrt(a), sqrt(1 - a));  
}

bool HCMPoint::intersectSimple(HCMPoint p, HCMPoint p2, HCMPoint q, HCMPoint q2, HCMPoint &intersection) {
  double s1_x = p2.longitude - p.longitude;
  double s1_y = p2.latitude - p.latitude;
  double s2_x = q2.longitude - q.longitude;
  double s2_y = q2.latitude - q.latitude;
  
  double den = -s2_x * s1_y + s1_x * s2_y;
  if (den == 0) { return false; }
  
  double s = (-s1_y * (p.longitude - q.longitude) + s1_x * (p.latitude - q.latitude)) / den;
  double t = ( s2_x * (p.latitude - q.latitude) - s2_y * (p.longitude - q.longitude)) / den;
  
  if (s >= 0 && s <= 1 && t >= 0 && t <= 1) {
    intersection.latitude = p.latitude + (t * s1_y);
    intersection.longitude = p.longitude + (t * s1_x);
    return true;
  }
  
  return false;
}