//
// Copyright (c) 2015 Harry Cheung
//

package harrycheung.map.shared;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertThat;
import static org.junit.Assert.assertTrue;
import static org.hamcrest.CoreMatchers.is;
import harrycheung.map.shared.Gate;
import harrycheung.map.shared.GateType;
import harrycheung.map.shared.Point;

import org.junit.Test;

public final class GateTest {

  @Test
  public void crossed() {
    Gate gate = new Gate(GateType.START_FINISH, 1, 37.452602,-122.207069, 32);    
    Point a = new Point(37.452414, -122.207193, 14.210000038146973, 
        32.09501647949219, 0, 0, 1);
    Point b = new Point(37.452523, -122.207107, 14.239999771118164, 
        32.09501647949219, 0, 0, 2);
    b.lapDistance = 100.0;
    b.lapTime = 0.1;
    Point c = new Point(37.45263, -122.207023, 14.15999984741211, 
        32.09501647949219, 0, 0, 3);    
    assertNull(gate.crossed(a, b));
    assertNull(gate.crossed(c, b));
    Point cross = gate.crossed(b, c);
    assertTrue(cross.generated);
    assertThat(cross.getLatitudeDegrees(), is(37.452593));
    assertThat(cross.getLongitudeDegrees(), is(-122.207052));
    assertEquals(14.18, cross.speed, 0.01);
    assertEquals(31.93, cross.bearing, 0.01);
    assertEquals(2.64915, cross.timestamp, 0.00001);
    assertEquals(100 + b.distanceTo(cross), cross.lapDistance, 0.01);
    assertEquals(0.74915, cross.lapTime, 0.00001);
    assertEquals(0.64915, cross.splitTime, 0.00001);
  }
}