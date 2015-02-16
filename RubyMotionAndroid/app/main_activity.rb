class MainActivity < Android::App::Activity
  def onCreate(savedInstanceState)
    super
    
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
    @track = Track.new(Org::Json::JSONObject.new(track_json))
    
    layout = Android::Widget::LinearLayout.new(self)
    layout.orientation = Android::Widget::LinearLayout::VERTICAL
    @button1000 = Android::Widget::Button.new(self)
    @button1000.text = "Run 1000"
    layout.addView(@button1000, Android::Widget::LinearLayout::LayoutParams.new(Android::View::ViewGroup::LayoutParams::MATCH_PARENT, 40))
    self.contentView = layout
    
    bufferedReader = Java::IO::BufferedReader.new(Java::IO::InputStreamReader.new(getAssets().open('multi_lap_session.csv')))
    @points = []
    while line = bufferedReader.readLine()
      parts = line.split(',');
      @points.push(Point.new(parts[0].to_f, 
        parts[1].to_f, speed: parts[2].to_f, bearing: parts[3].to_f, 
        horizontal_accuracy: 5, vertical_accuracy: 15, timestamp: 0))
    end
    bufferedReader.close();
  end
end
