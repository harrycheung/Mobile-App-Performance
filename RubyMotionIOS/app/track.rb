class Track

  attr_reader :id, :name, :gates, :start

  def initialize(json)
    track = json['track']
    @id = track['id']
    @name = track['name']
    @gates = []
    track['gates'].each do |gate|
      @gates.push(Gate.new(gate['gate_type'], gate['split_number'], gate['latitude'], gate['longitude'], gate['bearing']))
      if @gates[-1].gate_type == Gate::START or gates[-1].gate_type == Gate::START_FINISH
        @start = @gates[-1]
      end
    end

    raise 'No id' if @id.nil?
    raise 'No name' if @name.nil?
    raise 'No start' if @start.nil?
    raise 'No gates' if @gates.empty?
  end

  def distance_to_start(latitude, longitude)
    start.distance_to(Point.new(latitude, longitude))
  end
  
end
