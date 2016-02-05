//
// Copyright (c) 2015 Harry Cheung
//

var track = null;

QUnit.module( "Session", {
  beforeEach: function() {
    var trackJSON = ""
    + "{"
    +   "\"track\": {"
    +     "\"id\": \"1000\","
    +     "\"name\": \"Test Raceway\","
    +     "\"gates\": ["
    +       "{"
    +       "\"gate_type\": \"SPLIT\","
    +       "\"split_number\": \"1\","
    +       "\"latitude\": \"37.451775\","
    +       "\"longitude\": \"-122.203657\","
    +       "\"bearing\": \"136\""
    +       "},"
    +       "{"
    +       "\"gate_type\": \"SPLIT\","
    +       "\"split_number\": \"2\","
    +       "\"latitude\": \"37.450127\","
    +       "\"longitude\": \"-122.205499\","
    +       "\"bearing\": \"326\""
    +       "},"
    +       "{"
    +       "\"gate_type\": \"START_FINISH\","
    +       "\"split_number\": \"3\","
    +       "\"latitude\": \"37.452602\","
    +       "\"longitude\": \"-122.207069\","
    +       "\"bearing\": \"32\""
    +       "}"
    +     "]"
    +   "}"
    + "}";

    track = new Track(JSON.parse(trackJSON));
  }
});
QUnit.testDone(function( details ) {
  SessionManager.instance().endSession();
});

QUnit.test( "Session.single", function( assert ) {
  var lines = single_data.split("\n");
  var startTime = (new Date()).getTime() / 1000.0;
  SessionManager.instance().startSession(track);
  var session = SessionManager.instance().session;
  var length = lines.length;
  for (var i = 0; i < length; i++) {
    var line = lines[i];
    var parts = line.split(",");
    SessionManager.instance().gps(
      parseFloat(parts[0]),
      parseFloat(parts[1]),
      parseFloat(parts[2]),
      parseFloat(parts[3]),
      5.0,
      15.0,
      startTime);
    startTime++;
  }
  SessionManager.instance().endSession();

  var laps = session.laps;
  assert.equal( laps.length, 3 );
  assert.equal( laps[0].valid, false );
  assert.equal( laps[1].valid, true );
  assert.equal( laps[2].valid, false );
  assert.equal( laps[0].lapNumber, 0 );
  assert.equal( laps[1].lapNumber, 1 );
  assert.equal( laps[2].lapNumber, 2 );
  assert.close( 120.64222, laps[1].duration, 0.00001 );
  assert.close( 35.85215, laps[1].splits[0], 0.00001 );
  assert.close( 38.94201, laps[1].splits[1], 0.00001 );
  assert.close( 45.84806, laps[1].splits[2], 0.00001 );
  assert.close( 1298.63, laps[1].distance, 0.01 );
});

QUnit.test( "Session.multi", function( assert ) {
  var lines = multi_data.split("\n");
  var startTime = (new Date()).getTime() / 1000.0;
  SessionManager.instance().startSession(track)
  var session = SessionManager.instance().session;
  var length = lines.length;
  for (var i = 0; i < length; i++) {
    var line = lines[i];
    var parts = line.split(",");
    SessionManager.instance().gps(
      parseFloat(parts[0]),
      parseFloat(parts[1]),
      parseFloat(parts[2]),
      parseFloat(parts[3]),
      5.0,
      15.0,
      startTime);
    startTime++;
  }
  SessionManager.instance().endSession();

  var laps = session.laps;
  assert.equal( laps.length, 6 );
  assert.equal( laps[0].valid, false );
  assert.equal( laps[1].valid, true );
  assert.equal( laps[2].valid, true );
  assert.equal( laps[3].valid, true );
  assert.equal( laps[4].valid, true );
  assert.equal( laps[5].valid, false );
  assert.equal( laps[0].lapNumber, 0 );
  assert.equal( laps[1].lapNumber, 1 );
  assert.equal( laps[2].lapNumber, 2 );
  assert.equal( laps[3].lapNumber, 3 );
  assert.equal( laps[4].lapNumber, 4 );
  assert.equal( laps[5].lapNumber, 5 );
  assert.close( 120.64222, laps[1].duration, 0.00001 );
  assert.close( 100.01685, laps[2].duration, 0.00001 );
  assert.close(  96.74609, laps[3].duration, 0.00001 );
  assert.close(  94.61198, laps[4].duration, 0.00001 );
  assert.close( 1298.63, laps[1].distance, 0.01 );
  assert.close( 1298.69, laps[2].distance, 0.01 );
  assert.close( 1306.85, laps[3].distance, 0.01 );
  assert.close( 1306.55, laps[4].distance, 0.01 );
});
  