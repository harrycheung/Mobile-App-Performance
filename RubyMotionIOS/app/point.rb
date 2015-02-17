#
# Copyright (c) 2015 Harry Cheung
#

module Math
  def self.to_radians(value)
    value * PI / 180
  end

  def self.to_degrees(value)
    value * 180 / PI
  end
end

class Point
  RADIUS = 6371000

  attr_accessor :latitude, :longitude, :speed, :bearing
  attr_accessor :horizontal_accuracy, :vertical_accuracy
  attr_accessor :lap_distance, :lap_time, :acceleration
  attr_accessor :split_time, :generated, :timestamp

  def initialize(latitude, longitude, options = {})
    if options[:in_radians]
      @latitude  = latitude.to_f
      @longitude = longitude.to_f
    else
      @latitude  = Math.to_radians(latitude.to_f)
      @longitude = Math.to_radians(longitude.to_f)
    end
    @generated = false
    @speed     = (options[:speed] || 0).to_f
    @bearing   = (options[:bearing] || 0).to_f
    @horizontal_accuracy = (options[:horizontal_accuracy] || 0).to_f
    @vertical_accuracy = (options[:vertical_accuracy] || 0).to_f
    @timestamp = (options[:timestamp] || 0).to_f
    @lap_distance = 0.0
    @lap_time = 0.0
    @acceleration = 0.0
    @split_time = 0.0
  end

  def set_lap_time(start_time, split_start_time)
    @lap_time = @timestamp - start_time
    @split_time = @timestamp - split_start_time
  end

  def latitude_degrees
    Math.to_degrees(@latitude).round(6)
  end

  def longitude_degrees
    Math.to_degrees(@longitude).round(6)
  end

  def subtract(point)
    Point.new(@latitude - point.latitude, @longitude - point.longitude, in_radians: true)
  end

  def bearing_to(point, in_radians = false)
    lat1 = @latitude
    lat2 = point.latitude
    lon_delta = point.longitude - @longitude

    y = Math.sin(lon_delta) * Math.cos(lat2)
    x = Math.cos(lat1) * Math.sin(lat2) - Math.sin(lat1) * Math.cos(lat2) * Math.cos(lon_delta)
    omega = Math.atan2(y, x)

    in_radians ? (omega + 2 * Math::PI) % Math::PI : (Math.to_degrees(omega) + 2 * 360) % 360
  end

  def destination(bearing, distance) 
    omega = Math.to_radians(bearing.to_f)
    delta = distance.to_f / RADIUS
    lat1 = latitude
    lon1 = longitude
    lat2 = Math.asin(Math.sin(lat1) * Math.cos(delta) + Math.cos(lat1) * Math.sin(delta) * Math.cos(omega))
    lon2 = lon1 + Math.atan2(Math.sin(omega) * Math.sin(delta) * Math.cos(lat1), Math.cos(delta) - Math.sin(lat1) * Math.sin(lat2))
    lon2 = (lon2 + 3.0 * Math::PI) % (2.0 * Math::PI) - Math::PI # normalise to -180..+180
    Point.new(lat2, lon2, in_radians: true)
  end

  def distance_to(point)
    lat1 = latitude
    lon1 = longitude
    lat2 = point.latitude
    lon2 = point.longitude
    lat_delta = lat2 - lat1
    lon_delta = lon2 - lon1

    a = Math.sin(lat_delta / 2) * Math.sin(lat_delta / 2) + Math.cos(lat1) * Math.cos(lat2) * Math.sin(lon_delta / 2) * Math.sin(lon_delta / 2)
    RADIUS * 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
  end

  def self.intersect_simple(p, p2, q, q2)
    s1_x = p2.longitude - p.longitude
    s1_y = p2.latitude - p.latitude
    s2_x = q2.longitude - q.longitude
    s2_y = q2.latitude - q.latitude

    den = (-s2_x * s1_y + s1_x * s2_y)
    return nil if den == 0

    s = (-s1_y * (p.longitude - q.longitude) + s1_x * (p.latitude - q.latitude)) / den
    t = ( s2_x * (p.latitude - q.latitude) - s2_y * (p.longitude - q.longitude)) / den

    if s >= 0 && s <= 1 && t >= 0 && t <= 1
      Point.new(p.latitude + (t * s1_y), p.longitude + (t * s1_x), in_radians: true)
    else
      nil
    end
  end

end