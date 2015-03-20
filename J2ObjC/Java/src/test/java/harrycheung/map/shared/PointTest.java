//
// Copyright (c) 2015 Harry Cheung
//

package harrycheung.map.shared;

import static org.junit.Assert.*;
import static org.hamcrest.CoreMatchers.*;
import static java.lang.Math.round;
import harrycheung.map.shared.Point;

import org.junit.Test;

public final class PointTest {

  @Test
  public void equals() {
    Point a = new Point(14, 14);
    Point b = new Point(14, 14);
    Point c = new Point(25, 25);

    assertThat(a, equalTo(b));
    assertThat(a, not(equalTo(c)));
  }

  @Test
  public void subtraction() {
    Point a = new Point(5, 5);
    Point b = new Point(10, 10);
    Point c = b.subtract(a);

    assertThat(c.getLatitudeDegrees(), is(5.0));
    assertThat(c.getLongitudeDegrees(), is(5.0));
  }

  @Test
  public void bearingTo() {
    Point a = new Point(5, 5);
    Point b = new Point(5, 10);

    assertThat(a.bearingTo(b), is(89.781973));
    assertThat(a.bearingTo(b, true), is(1.566991));
  }

  @Test
  public void destination() {
    Point a = new Point(37.452602, -122.207069);
    Point d = a.destination(308, 50);

    assertThat(d, equalTo(new Point(37.452879, -122.207515)));
  }

  @Test
  public void distanceTo() {
    Point a = new Point(50.06639, -5.71472);
    Point b = new Point(58.64389, -3.07000);

    assertThat((int)round(a.distanceTo(b)), is(968854));
  }

  @Test
  public void intersect() {
    Point a = new Point(5, 5);
    Point b = new Point(15, 15);
    Point c = new Point(5, 15);
    Point d = new Point(15, 5);
    Point i = Point.intersectSimple(a, b, c, d);

    assertThat(i.getLatitudeDegrees(), is(10.0));
    assertThat(i.getLongitudeDegrees(), is(10.0));
  }
}