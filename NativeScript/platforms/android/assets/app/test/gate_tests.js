//
// Copyright (c) 2015 Harry Cheung
//

QUnit.module( "Gate" );
QUnit.test( "Gate.crossed", function( assert ) {
  var gate = new Gate(GateType.START_FINISH, 1, 37.452602, -122.207069, 32);
  var a = new Point(37.452414, -122.207193, false, 14.210000038146973, 32.09501647949219, 0, 0, 1 );
  var b = new Point(37.452523, -122.207107, false, 14.239999771118164, 32.09501647949219, 0, 0, 2);
  b.lapDistance = 100.0;
  b.lapTime = 0.1;
  var c = new Point(37.45263, -122.207023, false, 14.15999984741211, 32.09501647949219, 0, 0, 3);
  var cross = gate.crossed(b, c);
  
  assert.equal( gate.crossed(a, b), null );
  assert.equal( gate.crossed(c, b), null );
  assert.equal( cross.generated, true );
  assert.equal( cross.latitudeDegrees(), 37.452593 );
  assert.equal( cross.longitudeDegrees(), -122.207052 );
  assert.close( cross.speed, 14.18, 0.01 );
  assert.close( cross.bearing, 31.93, 0.01 );
  assert.close( cross.timestamp, 2.64915, 0.00001 );
  assert.close( cross.lapDistance, b.lapDistance + b.distanceTo(cross), 0.01 );
  assert.close( cross.lapTime, 0.74915, 0.00001 );
  assert.close( cross.splitTime, 0.64915, 0.00001 );
});