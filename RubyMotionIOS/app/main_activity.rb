#
# Copyright (c) 2015 Harry Cheung
#

class MainActivity < UIViewController

  def viewDidLoad
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

    @track = Track.new(JSON.parse(track_json))

    view.backgroundColor = UIColor.whiteColor
    frame = view.bounds
    width  = frame.size.width
    @button_1000 = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @button_1000.frame = CGRectMake(0, 40, width / 2 - 20, 30)
    @button_1000.setTitle('run 1000', forState: UIControlStateNormal)
    @button_1000.addTarget(self,
                     action: 'click_1000',
                     forControlEvents: UIControlEventTouchUpInside)
    view.addSubview(@button_1000)
    @label_1000 = UILabel.alloc.init
    @label_1000.frame = CGRectMake(0, 80, width / 2 - 20, 30)
    @label_1000.textAlignment = UITextAlignmentCenter
    view.addSubview(@label_1000)

    @button_10000 = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @button_10000.frame = CGRectMake(0, 200, width / 2 - 20, 30)
    @button_10000.setTitle('run 10000', forState: UIControlStateNormal)
    @button_10000.addTarget(self,
                           action: 'click_10000',
                           forControlEvents: UIControlEventTouchUpInside)
    view.addSubview(@button_10000)
    @label_10000 = UILabel.alloc.init
    @label_10000.frame = CGRectMake(0, 240, width / 2 - 20, 30)
    @label_10000.textAlignment = UITextAlignmentCenter
    view.addSubview(@label_10000)

    multi_lap = File.read(File.join(NSBundle.mainBundle.resourcePath, 'multi_lap_session.csv'))
    @points = []
    multi_lap.each_line { |line|
      parts = line.split(',')
      @points.push(Point.new(parts[0].to_f, parts[1].to_f, speed: parts[2].to_f, bearing: parts[3].to_f,
                             horizontal_accuracy: 5, vertical_accuracy: 15, timestamp: 0))
    }
  end

  def click_1000
    start = Time.now
    start_time = Time.now.to_f
    1000.times do |n|
      autorelease_pool {
        SessionManager.start_session(@track)
        @points.each { |point|
          SessionManager.gps(point.latitude_degrees, point.longitude_degrees, point.speed, point.bearing, 5, 15, start_time)
          start_time += 1
        }
        SessionManager.end_session
      }
    end
    @label_1000.text = (Time.now - start).format(3)
  end

  def click_10000
    start = Time.now
    start_time = Time.now.to_f
    10000.times do |n|
      autorelease_pool {
        SessionManager.start_session(@track)
        @points.each { |point|
          SessionManager.gps(point.latitude_degrees, point.longitude_degrees, point.speed, point.bearing, 5, 15, start_time)
          start_time += 1
        }
        SessionManager.end_session
      }
    end
    @label_10000.text = (Time.now - start).format(3)
  end

end