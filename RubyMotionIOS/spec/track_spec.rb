describe 'Track tests' do

  it 'load single track from json' do
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

    track = Track.new(JSON.parse(track_json))

    track.id.should.equal 1000
    track.name.should.equal 'Isabella Raceway'
    track.gates.length.should.equal 3
  end

  it 'should load array of tracks' do
    track_json = '[{
      "track": {
        "id": 1000,
        "name": "Isabella Raceway",
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
    }]'

    track = Track.new(JSON.parse(track_json)[0])

    track.id.should.equal 1000
    track.name.should.equal 'Isabella Raceway'
    track.gates.length.should.equal 3
  end

  it 'should fail to load track' do
    track_json = '{
      "track": {
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

    should.raise(RuntimeError) { Track.new(JSON.parse(track_json)) }
  end

end
