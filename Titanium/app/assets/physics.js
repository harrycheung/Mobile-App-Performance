//
// Copyright (c) 2015 Harry Cheung
//

var Physics = Physics || {};
  
// x = vt + 1/2att
Physics.distance = function(velocity, acceleration, time) {
  return velocity * time + (acceleration * time * time) / 2.0;
};

// t = (-v + sqrt(2vvax)) / a (quadratic)
Physics.time = function(distance, velocity, acceleration) {
  if (acceleration == 0) {
    return distance / velocity;
  } else {
    return (-velocity + Math.sqrt(velocity * velocity + 2.0 * acceleration * distance)) / acceleration;
  }
};