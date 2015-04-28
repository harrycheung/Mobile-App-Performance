//
//  Copyright (c) 2015 Harry Cheung
//

import UIKit
import XCTest

class PointTests: XCTestCase {
  
  func testEquals() {
    let a = Point(latitude: 14, longitude: 14)
    let b = Point(latitude: 14, longitude: 14)
    let c = Point(latitude: 25, longitude: 25)
    
    XCTAssertEqual(a, b)
    XCTAssertNotEqual(a, c)
  }
  
  func testSubtraction() {
    let a = Point(latitude: 5, longitude: 5)
    let b = Point(latitude: 10, longitude: 10)
    let c = b.subtract(a)
    
    XCTAssertEqual(c.latitudeDegrees(), 5.0)
    XCTAssertEqual(c.longitudeDegrees(), 5.0)
  }
  
  func testBearingTo() {
    let a = Point(latitude: 5, longitude: 5)
    let b = Point(latitude: 5, longitude: 10)
    
    XCTAssertEqual(a.bearingTo(b), 89.781973)
    XCTAssertEqual(a.bearingTo(b, inRadians: true), 1.566991)
  }
  
  func testDestination() {
    let a = Point(latitude: 37.452602, longitude: -122.207069)
    let d = a.destination(308, distance: 50)
    
    XCTAssertEqual(d, Point(latitude: 37.452879, longitude: -122.207515))
  }
  
  func testDistanceTo() {
    let a = Point(latitude: 50.06639, longitude: -5.71472)
    let b = Point(latitude: 58.64389, longitude: -3.07000)
    
    XCTAssertEqualWithAccuracy(a.distanceTo(b), 968853.52, 0.001)
  }
  
  func testIntersectSimple() {
    let a = Point(latitude: 5, longitude: 5)
    let b = Point(latitude: 15, longitude: 15)
    let c = Point(latitude: 5, longitude: 15)
    let d = Point(latitude: 15, longitude: 5)
    var intersection = Point()
    Point.intersectSimple(p: a, p2: b, q: c, q2: d, intersection: &intersection)
    
    XCTAssertEqual(intersection, Point(latitude: 10, longitude: 10))
  }
  
}
