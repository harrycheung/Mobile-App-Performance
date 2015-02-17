#
# Copyright (c) 2015 Harry Cheung
#

describe 'Session tests' do

  before do
    track_json = '{
      "track": {
        "id": 1000,
        "name": "Test Raceway",
        "gates": [
          {
            "gate_type": "SPLIT",
            "latitude": 37.451775,
            "longitude": -122.203657,
            "bearing": 136,
            "split_number": 1
          },
          {
            "gate_type": "SPLIT",
            "latitude": 37.450127,
            "longitude": -122.205499,
            "bearing": 326,
            "split_number": 2
          },
          {
            "gate_type": "START_FINISH",
            "latitude": 37.452602,
            "longitude": -122.207069,
            "bearing": 32,
            "split_number": 3
          }
        ]
      }
    }'

    @track = Track.new(JSON.parse(track_json))
  end

  after do
    SessionManager.end_session
  end

  it 'handles a single lap session' do
    start_time = Time.now.to_f
    SessionManager.start_session(@track)

    single_lap = File.read(File.join(NSBundle.mainBundle.resourcePath, 'single_lap_session.csv'))
    single_lap.each_line { |line|
      parts = line.split(',')
      SessionManager.gps(parts[0].to_f, parts[1].to_f, parts[2].to_f, parts[3].to_f, 5, 15, start_time)
      start_time += 1
    }

    SessionManager.session.laps.length.should.equal 3
    SessionManager.session.laps[0].valid.should.equal false
    SessionManager.session.laps[1].valid.should.equal true
    SessionManager.session.laps[2].valid.should.equal false
    SessionManager.session.laps[0].lap_number.should.equal 0
    SessionManager.session.laps[1].lap_number.should.equal 1
    SessionManager.session.laps[2].lap_number.should.equal 2
    SessionManager.session.laps[1].duration.should.be.close 120.64222, 0.00001
    SessionManager.session.laps[1].splits[0].should.be.close 35.85215, 0.00001
    SessionManager.session.laps[1].splits[1].should.be.close 38.94201, 0.00001
    SessionManager.session.laps[1].splits[2].should.be.close 45.84806, 0.00001
    SessionManager.session.laps[1].distance.should.be.close 1298.57, 0.01
    SessionManager.best_lap_time.should.equal SessionManager.session.laps[1].duration
  end

  it 'handles a multi lap session' do
    start_time = Time.now.to_f
    SessionManager.start_session(@track)

    multi_lap = File.read(File.join(NSBundle.mainBundle.resourcePath, 'multi_lap_session.csv'))
    multi_lap.each_line { |line|
      parts = line.split(',')
      SessionManager.gps(parts[0].to_f, parts[1].to_f, parts[2].to_f, parts[3].to_f, 5, 15, start_time)
      start_time += 1
    }

    SessionManager.session.laps.length.should.equal 6
    SessionManager.session.laps[0].valid.should.equal false
    SessionManager.session.laps[1].valid.should.equal true
    SessionManager.session.laps[2].valid.should.equal true
    SessionManager.session.laps[3].valid.should.equal true
    SessionManager.session.laps[4].valid.should.equal true
    SessionManager.session.laps[5].valid.should.equal false
    SessionManager.session.laps[0].lap_number.should.equal 0
    SessionManager.session.laps[1].lap_number.should.equal 1
    SessionManager.session.laps[2].lap_number.should.equal 2
    SessionManager.session.laps[3].lap_number.should.equal 3
    SessionManager.session.laps[4].lap_number.should.equal 4
    SessionManager.session.laps[5].lap_number.should.equal 5
    SessionManager.session.laps[1].duration.should.be.close 120.64222, 0.00001
    SessionManager.session.laps[2].duration.should.be.close 100.01685, 0.00001
    SessionManager.session.laps[3].duration.should.be.close 96.74609, 0.00001
    SessionManager.session.laps[4].duration.should.be.close 94.61198, 0.00001
    SessionManager.session.laps[1].distance.should.be.close 1298.57, 0.01
    SessionManager.session.laps[2].distance.should.be.close 1298.64, 0.01
    SessionManager.session.laps[3].distance.should.be.close 1306.80, 0.01
    SessionManager.session.laps[4].distance.should.be.close 1306.50, 0.01
    SessionManager.best_lap_time.should.equal SessionManager.session.laps[4].duration
  end
end
