#
# Copyright (c) 2015 Harry Cheung
#

class Gate < Point

  START_FINISH = 'START_FINISH'
  START = 'START'
  FINISH = 'FINISH'
  SPLIT = 'SPLIT'

  LINE_WIDTH = 80
  BEARING_RANGE = 90

  attr_reader :gate_type, :split_number

  def initialize(gate_type, split_number, latitude, longitude, bearing)
    super(latitude, longitude, bearing: bearing)

    @gate_type = gate_type
    @split_number = split_number
    left_bearing = bearing - 90 < 0 ? bearing + 270 : bearing - 90
    right_bearing = bearing + 90 > 360 ? bearing - 270 : bearing + 90
    @left_point = destination(left_bearing, LINE_WIDTH / 2)
    @right_point = destination(right_bearing, LINE_WIDTH / 2)
  end

  def cross(start, destination)
    path_bearing = start.bearing_to(destination)
    cross = nil
    if path_bearing > bearing - BEARING_RANGE and
        path_bearing < bearing + BEARING_RANGE
      cross = Point.intersect_simple(@left_point, @right_point, start, destination)
    end
    unless cross.nil?
      distance = start.distance_to(cross)
      acceleration = (destination.speed - start.speed) / (destination.timestamp - start.timestamp)
      time = Physics.time(distance, start.speed, acceleration)
      cross.generated = true
      cross.speed = start.speed + acceleration * time
      cross.bearing = start.bearing_to(destination)
      cross.timestamp = start.timestamp + time
      cross.lap_distance = start.lap_distance + distance
      cross.lap_time = start.lap_time + time
      cross.split_time = start.split_time + time
    end
    cross
  end

end