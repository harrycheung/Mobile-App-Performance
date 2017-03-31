import Point from './point';
import Track from './track';
import SessionManager from './session_manager';
import multi_data from './multi';

const track = new Track({
  'track': {
    'id': '1000',
    'name': 'Test Raceway',
    'gates': [{
      'gate_type': 'SPLIT',
      'split_number': '1',
      'latitude': '37.451775',
      'longitude': '-122.203657',
      'bearing': '136'
    }, {
      'gate_type': 'SPLIT',
      'split_number': '2',
      'latitude': '37.450127',
      'longitude': '-122.205499',
      'bearing': '326'
    }, {
      'gate_type': 'START_FINISH',
      'split_number': '3',
      'latitude': '37.452602',
      'longitude': '-122.207069',
      'bearing': '32'
    }]
  }
});

const points = [];
const lines = multi_data.split('\n');
const length = lines.length;

for (let i = 0; i < length; i++) {
  const line = lines[i];
  const parts = line.split(',');

  points.push(new Point(
    parseFloat(parts[0]),
    parseFloat(parts[1]),
    false,
    parseFloat(parts[2]),
    parseFloat(parts[3]),
    5.0,
    15.0,
    0));
}

export default class ReactNativeBenchmark {
  static run(count) {
    const start = (new Date()).getTime() / 1000.0;
    let timestamp = start;

    while (count--) {
      SessionManager.instance().startSession(track);

      const pointsLength = points.length;

      for (let i = 0; i < pointsLength; i++) {
        const point = points[i];
        SessionManager.instance().gps(point.latitudeDegrees(), point.longitudeDegrees(),
          point.speed, point.bearing, point.hAccuracy, point.vAccuracy, timestamp++);
      }
      SessionManager.instance().endSession();
    }
    return (new Date()).getTime() / 1000.0 - start;
  }
}
