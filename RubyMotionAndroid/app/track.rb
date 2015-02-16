class Track

  attr_reader :id, :name, :gates, :start

  def initialize(json)
    track = json.getJSONObject('track')
    @id = track.getInt('id').intValue
    @name = track.getString('name')
    @gates = []
    jsonGates = track.getJSONArray('gates')
    jsonGates.length.times do |n|
      gate = jsonGates.getJSONObject(n)
      @gates.push(Gate.new(gate.getString('gate_type'), 
                           gate.getInt('split_number').intValue, 
                           gate.getDouble('latitude').floatValue,
                           gate.getDouble('longitude').floatValue, 
                           gate.getDouble('bearing').floatValue))
      if @gates[-1].gate_type == Gate::START or gates[-1].gate_type == Gate::START_FINISH
        @start = @gates[-1]
      end
    end

    raise 'No id' if @id.nil?
    raise 'No name' if @name.nil?
    raise 'No start' if @start.nil?
    raise 'No gates' if @gates.empty?
  end
  
end