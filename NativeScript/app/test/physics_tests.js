//
// Copyright (c) 2015 Harry Cheung
//

QUnit.module( "Physics" );
QUnit.test( "Physics.distance", function( assert ) {
  assert.equal( Physics.distance(0, 0, 0), 0.0 );
  assert.equal( Physics.distance(1, 1, 1), 1.5 );
  assert.equal( Physics.distance(2, 2, 2), 8.0 );
  assert.equal( Physics.distance(3, 0, 3), 9.0 );
});

QUnit.test( "Physics.time", function( assert ) {
  assert.equal( Physics.time(1.5, 1, 1), 1.0 );
  assert.equal( Physics.time(8.0, 2, 2), 2.0 );
  assert.equal( Physics.time(9.0, 3, 0), 3.0 );
});
  