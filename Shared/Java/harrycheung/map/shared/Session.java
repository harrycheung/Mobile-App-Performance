//
// Copyright (c) 2015 Harry Cheung
//

package harrycheung.map.shared;

import java.util.ArrayList;
import java.util.List;

public final class Session {

  protected Track track;
  protected double startTime;
  protected double duration = 0;
  protected List<Lap> laps = new ArrayList<Lap>();

  public Session(Track track, double startTime) {
    this.track     = track;
    this.startTime = startTime;
  }

  public void tick(double currentTime) {
    duration = currentTime - startTime;
  }
}