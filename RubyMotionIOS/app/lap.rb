#
# Copyright (c) 2015 Harry Cheung
#

class Lap

  attr_reader :track, :start_time, :lap_number, :points, :duration, :distance
  attr_accessor :splits, :valid
  alias_method :valid?, :valid

  def initialize(session, track, start_time, lap_number)
    @session = WeakRef.new(session)
    @track = WeakRef.new(track)
    @start_time = start_time
    @lap_number = lap_number
    @points = []
    @duration = 0.0
    @distance = 0.0
    @valid = false
    @splits = Array.new(track.gates.length, 0.0)
  end

  def add(point)
    @duration = point.lap_time
    @distance = point.lap_distance
    @points.push(point)
  end

end