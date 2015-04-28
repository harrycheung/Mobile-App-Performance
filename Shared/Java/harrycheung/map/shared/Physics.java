//
// Copyright (c) 2015 Harry Cheung
//

package harrycheung.map.shared;

public final class Physics {
  private Physics() {}

  // x = vt + 1/2att
  public static double distance(double velocity,
      double acceleration,
      double time) {
    return velocity * time + (acceleration * time * time) / 2;
  }

  // t = (-v + sqrt(2vvax)) / a (quadratic)
  public static double time(double distance,
      double velocity,
      double acceleration) {
    if (acceleration == 0) {
      return distance / velocity;
    } else {
      return (-velocity +
          Math.sqrt(velocity * velocity + 2 * acceleration * distance)) /
          acceleration;
    }
  }
}