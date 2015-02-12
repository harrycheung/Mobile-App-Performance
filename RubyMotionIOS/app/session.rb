class Session

  attr_reader :track, :start_time, :duration
  attr_accessor :laps

  def initialize(track, start_time)
    @track = WeakRef.new(track)
    @start_time = start_time
    @duration = 0.0
    @laps = []
  end

end