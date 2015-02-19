//
//  Copyright (c) 2015 Harry Cheung
//

import Foundation

final class Physics {
  
  // x = vt + 1/2att
  class func distance(#velocity: Double, acceleration: Double, time: Double) -> Double {
    return velocity * time + (acceleration * time * time) / 2
  }
  
  // t = (-v + sqrt(2vvax)) / a (quadratic)
  class func time(#distance: Double, velocity: Double, acceleration: Double) -> Double {
    if (acceleration == 0) {
      return distance / velocity;
    } else {
      return (-velocity + sqrt(velocity * velocity + 2 * acceleration * distance)) / acceleration
    }
  }

}