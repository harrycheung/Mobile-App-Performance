//
// Copyright (c) 2015 Harry Cheung
//

QUnit.module( "Track" );
QUnit.test( "Track.load", function( assert ) {
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
  
  var track = new Track(JSON.parse(trackJSON));
  
  assert.equal( track.id, 1000 );
  assert.equal( track.name, "Test Raceway" );
  assert.equal( track.numSplits(), 3 );
});
  