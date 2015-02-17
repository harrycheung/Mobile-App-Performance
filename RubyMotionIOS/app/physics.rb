#
# Copyright (c) 2015 Harry Cheung
#

module Physics

  # x = vt + 1/2att
  def self.distance(velocity, acceleration, time)
    velocity = velocity.to_f
    acceleration = acceleration.to_f
    time = time.to_f
    velocity * time + (acceleration * time * time) / 2
  end

  # t = (-v + sqrt(2vvax)) / a (quadratic)
  def self.time(distance, velocity, acceleration)
    distance = distance.to_f
    velocity = velocity.to_f
    acceleration = acceleration.to_f
    if acceleration == 0
      distance / velocity
    else
      (-velocity + Math.sqrt(velocity * velocity + 2 * acceleration * distance)) / acceleration
    end
  end

end