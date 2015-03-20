//
// Copyright (c) 2015 Harry Cheung
//

package harrycheung.map.shared;

import java.util.*;

public class SessionManager {

  protected Session session;
  protected Lap currentLap;
  protected Lap bestLap;
  protected Track track;
  private int bestIndex;
  private double gap;
  private double[] splitGaps;
  private int currentSplit;
  private Gate nextGate;
  private Point lastPoint;
  private int lapNumber;
  private double splitStartTime;

  // Singleton
  protected static SessionManager instance = new SessionManager();
  public static SessionManager getInstance() { return instance; }
  private SessionManager() { }

  public void startSession(Track track) {
    if (session == null) {
      this.track = track;
      session = new Session(track, System.currentTimeMillis() / 1000.0);
      currentLap = new Lap(session, track, session.startTime, 0);
      session.laps.add(currentLap);
      nextGate = track.start;
      lastPoint = null;
      lapNumber = 0;
      splitStartTime = session.startTime;
      if (bestLap != null) { bestIndex = 0; }
      splitGaps = new double[track.numSplits()];
    }
  }

  public void endSession() {
    if (session != null) {
      session = null;
    }
  }

  public void gps(double latitude, double longitude, double speed,
      double bearing, double horizontalAccuracy,
      double verticalAccuracy, double timestamp) {
    Point point = new Point(latitude, longitude, speed, bearing,
        horizontalAccuracy, verticalAccuracy, timestamp);
    if (lastPoint != null) {
      Point cross = nextGate.crossed(lastPoint, point);
      if (cross != null) {
        currentLap.add(cross);
        currentLap.splits[currentSplit] = cross.splitTime;
        switch (nextGate.type) {
        case START_FINISH:
        case FINISH:
          if (currentLap.points.get(0).generated) {
            currentLap.valid = true;
            if (bestLap == null || currentLap.duration < bestLap.duration) {
              bestLap = currentLap;
            }
          }
        case START:
          lapNumber++;
          currentLap = new Lap(session, track, cross.timestamp, lapNumber);
          lastPoint = new Point(cross.getLatitudeDegrees(), cross.getLongitudeDegrees(), cross.speed, cross.bearing,
              cross.hAccuracy, cross.vAccuracy, cross.timestamp);
          lastPoint.lapDistance = 0;
          lastPoint.lapTime = 0;
          lastPoint.generated = true;
          currentLap.add(lastPoint);
          session.laps.add(currentLap);
          gap = 0;
          Arrays.fill(splitGaps, 0);
          bestIndex = 0;
          currentSplit = 0;
          break;
        case SPLIT:
          if (bestLap != null) {
            splitGaps[currentSplit] = currentLap.splits[currentSplit] - bestLap.splits[currentSplit];
          }
          currentSplit++;
        default:
          break;
        }
        splitStartTime = cross.timestamp; 
        nextGate = track.gates[currentSplit];
      }
      if (bestLap != null && bestIndex < bestLap.points.size()) {
        while (bestIndex < bestLap.points.size()) {
          Point refPoint = bestLap.points.get(bestIndex);
          if (refPoint.lapDistance > currentLap.distance) {
            Point lastRefPoint = bestLap.points.get(bestIndex - 1);
            double distanceToLastRefPoint = currentLap.distance - lastRefPoint.lapDistance;
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
      point.lapDistance = lastPoint.lapDistance + lastPoint.distanceTo(point);
      point.setLapTime(currentLap.startTime, splitStartTime);
    }
    currentLap.add(point);
    lastPoint = point;
  }

}