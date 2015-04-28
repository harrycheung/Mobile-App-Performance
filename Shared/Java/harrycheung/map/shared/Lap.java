//
// Copyright (c) 2015 Harry Cheung
//

package harrycheung.map.shared;

import java.util.ArrayList;
import java.util.List;

public final class Lap {

  protected Track    track;
  protected double   startTime;
  protected int      lapNumber;
  protected List<Point> points;
  protected double   duration;
  protected double   distance;
  protected boolean  valid;
  protected double[] splits;
  protected boolean  outLap;

  public Lap(Session session, Track track, double startTime, int lapNumber) {
    this.track = track;
    this.startTime = startTime;
    this.lapNumber = lapNumber;
    this.points = new ArrayList<Point>();
    this.duration = 0;
    this.distance = 0;
    this.valid = false;
    this.splits = new double[track.numSplits()];
    this.outLap = lapNumber == 0;
  }

  public void add(Point point) {
    duration = point.lapTime;
    distance = point.lapDistance;
    points.add(point);
  }

}