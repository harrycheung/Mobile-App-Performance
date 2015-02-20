//
// Copyright (c) 2015 Harry Cheung
//

QUnit.module( "Point" );
QUnit.test( "Point.subtraction", function( assert ) {
  var a = new Point(5, 5);
  var b = new Point(10, 10);
  var c = b.subtract(a);
    
  assert.equal( c.latitudeDegrees(), 5.0 );
  assert.equal( c.longitudeDegrees(), 5.0 );
});

QUnit.test( "Point.bearing", function( assert ) {
  var a = new Point(5, 5);
  var b = new Point(5, 10);
  var c = b.subtract(a);
    
  assert.equal( a.bearingTo(b), 89.781973 );
  assert.equal( a.bearingTo(b, true), 1.566991 );
});

QUnit.test( "Point.destination", function( assert ) {
  var a = new Point(37.452602, -122.207069);
  var d = a.destination(308.0, 50.0);
    
  assert.equal( d.latitudeDegrees(), 37.452879 );
  assert.equal( d.longitudeDegrees(), -122.207515 );
});

QUnit.test( "Point.distance", function( assert ) {
  var a = new Point(50.06639, -5.71472);
  var b = new Point(58.64389, -3.07000);
    
  assert.close( a.distanceTo(b), 968853.52, 0.001 );
});

QUnit.test( "Point.intersect", function( assert ) {
  var a = new Point(5, 5);
  var b = new Point(15, 15);
  var c = new Point(5, 15);
  var d = new Point(15, 5);
  var i = Point.intersectSimple(a, b, c, d);
    
  assert.equal( i.latitudeDegrees(), 10 );
  assert.equal( i.longitudeDegrees(), 10 );
});