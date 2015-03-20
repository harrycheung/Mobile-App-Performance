//
// Copyright (c) 2015 Harry Cheung
//

package harrycheung.map.shared;

import static java.lang.Math.*;

public class Point {

  private static final double RADIUS = 6371000;

  protected double latitude, longitude;

  public double speed;

  public double bearing;
  public double hAccuracy, vAccuracy, timestamp;
  public double lapDistance, lapTime, acceleration;
  public double splitTime;
  public boolean generated;

  public Point(double latitude, double longitude, boolean inRadians) {
    if (inRadians) {
      this.latitude  = latitude;
      this.longitude = longitude;
    } else {
      this.latitude  = Math.toRadians(latitude);
      this.longitude = Math.toRadians(longitude);
    }
    this.generated = false;
  }

  public Point(double latitude, double longitude) {
    this(latitude, longitude, false);
  }

  public Point(double latitude, double longitude, double bearing) {
    this(latitude, longitude, false);
    this.bearing = bearing;
  }

  public Point(double latitude, double longitude, double speed, double bearing,
      double horizontalAccuracy, double verticalAccuracy, double timestamp) {
    this(latitude, longitude, false);
    this.speed     = speed;
    this.bearing   = bearing;
    this.hAccuracy = horizontalAccuracy;
    this.vAccuracy = verticalAccuracy;
    this.timestamp = timestamp;
  }

  public boolean equals(Object point) {
    // Compare degrees since radians has too many significant digits.
    return getLatitudeDegrees() == ((Point)point).getLatitudeDegrees() &&
        getLongitudeDegrees() == ((Point)point).getLongitudeDegrees();
  }

  public String toString() {
    return "Point: " + getLatitudeDegrees() + "," + getLongitudeDegrees();
  }

  public void setLapTime(double startTime, double splitStartTime) {
    lapTime = timestamp - startTime;
    splitTime = timestamp - splitStartTime;
  }

  private double roundValue(double value) {
    return round(value * 1000000.0) / 1000000.0;
  }

  public double getLatitudeDegrees() {
    return roundValue(toDegrees(this.latitude));
  }

  public double getLongitudeDegrees() {
    return roundValue(toDegrees(this.longitude));
  }

  public double getSpeed() {
	return speed;
  }

  public double getBearing() {
	return bearing;
  }

  public double getHorizontalAccuracy() {
	return hAccuracy;
  }

  public double getVerticalAccuracy() {
	return vAccuracy;
  }

  public Point subtract(Point Point) {
    return new Point(this.latitude - Point.latitude, this.longitude - Point.longitude, true);
  }

  public double bearingTo(Point Point, boolean inRadians) {
    double φ1 = latitude;
    double φ2 = Point.latitude;
    double Δλ = Point.longitude - this.longitude;

    double y = sin(Δλ) * cos(φ2);
    double x = cos(φ1) * sin(φ2) - sin(φ1) * cos(φ2) * cos(Δλ);
    double θ = atan2(y, x);

    if (inRadians) {
      return roundValue((θ + 2 * PI) % PI);
    } else {
      return roundValue((toDegrees(θ) + 2 * 360) % 360);
    }
  }

  public double bearingTo(Point Point) {
    return this.bearingTo(Point, false);
  }

  public Point destination(double bearing, double distance) {
    double θ  = toRadians(bearing);
    double δ  = distance / RADIUS;
    double φ1 = latitude;
    double λ1 = longitude;
    double φ2 = asin(sin(φ1) * cos(δ) + cos(φ1) * sin(δ) * cos(θ));
    double λ2 = λ1 + atan2(sin(θ) * sin(δ) * cos(φ1), cos(δ) - sin(φ1) * sin(φ2));
    λ2 = (λ2 + 3.0 * PI) % (2.0 * PI) - PI; // normalise to -180..+180

    return new Point(φ2, λ2, true);
  }

  public double distanceTo(Point point) {
    double φ1 = latitude;
    double λ1 = longitude;
    double φ2 = point.latitude;
    double λ2 = point.longitude;
    double Δφ = φ2 - φ1;
    double Δλ = λ2 - λ1;

    double a = sin(Δφ / 2) * sin(Δφ / 2) + cos(φ1) * cos(φ2) * sin(Δλ / 2) * sin(Δλ / 2);

    return RADIUS * 2 * atan2(sqrt(a), sqrt(1 - a));
  }

  public static Point intersectSimple(Point p, Point p2, Point q, Point q2) {
    double s1_x = p2.longitude - p.longitude;
    double s1_y = p2.latitude - p.latitude;
    double s2_x = q2.longitude - q.longitude;
    double s2_y = q2.latitude - q.latitude;

    double den = (-s2_x * s1_y + s1_x * s2_y);
    if (den == 0) { return null; }

    double s = (-s1_y * (p.longitude - q.longitude) + s1_x * (p.latitude - q.latitude)) / den;
    double t = ( s2_x * (p.latitude - q.latitude) - s2_y * (p.longitude - q.longitude)) / den;

    if (s >= 0 && s <= 1 && t >= 0 && t <= 1) {
      return new Point(p.latitude + (t * s1_y), p.longitude + (t * s1_x), true);
    }

    return null;
  }

}