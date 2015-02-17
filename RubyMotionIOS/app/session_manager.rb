#
# Copyright (c) 2015 Harry Cheung
#

module SessionManager

  class SessionState

    attr_reader :gap, :best_lap, :session, :split_gaps, :current_lap, :lap_number

    def initialize(track, best_lap = nil)
      @start_time = Time.now.to_f
      @track = WeakRef.new(track)
      @session = Session.new(track, @start_time)
      @lap_number = 0
      @current_lap = Lap.new(@session, track, @start_time, @lap_number)
      @session.laps.push(@current_lap)
      @gap = 0
      @split_gaps = Array.new(track.gates.length, 0)
      @split_start_time = @start_time
      @current_split = 0
      @best_lap = best_lap
      @best_index = 0
      @next_gate = track.start
      @last_point = nil
    end

    def gps(latitude, longitude, speed, bearing, horizontal_accuracy, vertical_accuracy, timestamp)
      point = Point.new(latitude, longitude, speed: speed, bearing: bearing,
                        vertical_accuracy: vertical_accuracy,
                        horizontal_accuracy: horizontal_accuracy,
                        timestamp: timestamp)
      unless @last_point.nil?
        if cross = @next_gate.cross(@last_point, point)
          @current_lap.add(cross)
          @current_lap.splits[@current_split] = cross.split_time
          case @next_gate.gate_type
          when Gate::START_FINISH, Gate::FINISH, Gate::START
            if @next_gate.gate_type != Gate::START and @current_lap.points[0].generated
              @current_lap.valid = true
              if @best_lap.nil? or @current_lap.duration < @best_lap.duration
                @best_lap = @current_lap
              end
            end
            @current_lap = Lap.new(@session, @track, cross.timestamp, @lap_number += 1)
            cross = cross.clone
            cross.lap_distance = 0
            cross.lap_time = 0
            @last_point = cross
            @current_lap.add(cross)
            @session.laps.push(@current_lap)
            @gap = 0
            @split_gaps.fill(0)
            @best_index = 0
            @current_split = 0
          when Gate::SPLIT
            unless @best_lap.nil?
              @split_gaps[@current_split] =
                  @current_lap.splits[@current_split] - @best_lap.splits[@current_split]
            end
            @current_split += 1
          else
            # do nothing
          end
          if not @best_lap.nil? and @best_index < @best_lap.points.length - 1
            while @best_index < @best_lap.points.length - 1 do
              ref_point = @best_lap.points[@best_index + 1]
              break if ref_point.lap_distance > @current_lap.distance
              @best_index += 1
            end
            last_ref_point = @best_lap.points[@best_index]
            distance_to_last_ref_point = @current_lap.distance - last_ref_point.lap_distance
            if distance_to_last_ref_point > 0
              since_last_ref_point = distance_to_last_ref_point / point.speed
              @gap = point.lap_time - since_last_ref_point - last_ref_point.lap_time
              @split_gaps[@current_split] = point.split_time - since_last_ref_point - last_ref_point.split_time
            end
          end
          @split_start_time = cross.timestamp
          @next_gate = @track.gates[@current_split]
        end
        point.lap_distance = @last_point.lap_distance + @last_point.distance_to(point)
        point.set_lap_time(@current_lap.start_time, @split_start_time)
      end
      @current_lap.add(point)
      @last_point = point
    end

  end

  def self.start_session(track)
    @state = SessionState.new(track)
  end

  def self.end_session
    @state = nil
  end

  def self.gps(latitude, longitude, speed, bearing, horizontal_accuracy, vertical_accuracy, timestamp)
    @state.gps(latitude, longitude, speed, bearing, horizontal_accuracy, vertical_accuracy, timestamp)
  end

  def self.session
    @state.session
  end

  def self.best_lap_time
    @state.best_lap.duration
  end

end