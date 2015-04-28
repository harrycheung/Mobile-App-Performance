//
// Copyright (c) 2015 Harry Cheung
//

package harrycheung.map.shared;

public final class Gate extends Point {

  private static final int LINE_WIDTH    = 80;
  private static final int BEARING_RANGE = 90;

  protected GateType type;
  protected int splitNumber;
  private Point leftPoint, rightPoint;

  public Gate(GateType type, int splitNumber,
      double latitude, double longitude, double bearing) {
    super(latitude, longitude, bearing);

    this.type = type;
    this.splitNumber = splitNumber;
    double leftBearing  = bearing - 90 < 0 ? bearing + 270 : bearing - 90;
    double rightBearing = bearing + 90 > 360 ? bearing - 270 : bearing + 90;
    this.leftPoint  = destination(leftBearing, LINE_WIDTH / 2);
    this.rightPoint = destination(rightBearing, LINE_WIDTH / 2);
  }

  public Point crossed(Point start, Point destination) {
    double pathBearing = start.bearingTo(destination);
    Point cross = null;
    if (pathBearing > bearing - BEARING_RANGE &&
        pathBearing < bearing + BEARING_RANGE) {
      cross = Point.intersectSimple(leftPoint, rightPoint, start, destination);
      if (cross != null) {
        double distance = start.distanceTo(cross);
        double timeDifference = destination.timestamp - start.timestamp;
        double acceleration = (destination.speed - start.speed) / timeDifference;
        double time = Physics.time(distance, start.speed, acceleration);
        cross.generated = true;
        cross.speed = start.speed + acceleration * time;
        cross.bearing = start.bearingTo(destination);
        cross.timestamp = start.timestamp + time;
        cross.lapDistance = start.lapDistance + distance;
        cross.lapTime = start.lapTime + time;
        cross.splitTime = start.splitTime + time;
      }
    }
    return cross;
  }
}