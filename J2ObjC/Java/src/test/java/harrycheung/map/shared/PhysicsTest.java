//
// Copyright (c) 2015 Harry Cheung
//

package harrycheung.map.shared;

import static org.junit.Assert.assertThat;
import static org.hamcrest.CoreMatchers.is;
import harrycheung.map.shared.Physics;

import org.junit.Test;

public class PhysicsTest {

  @Test
  public void distance() {
    assertThat(Physics.distance(0, 0, 0), is(0.0));
    assertThat(Physics.distance(1, 1, 1), is(1.5));
    assertThat(Physics.distance(2, 2, 2), is(8.0));
    assertThat(Physics.distance(3, 0, 3), is(9.0));
  }

  @Test
  public void time() {
    assertThat(Physics.time(1.5, 1, 1), is(1.0));
    assertThat(Physics.time(8.0, 2, 2), is(2.0));
    assertThat(Physics.time(9.0, 3, 0), is(3.0));
  }
}
