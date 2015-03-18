//
//  Copyright (c) 2015 Harry Cheung
//

import UIKit
import XCTest

class GateTests: XCTestCase {
  
  func testCrossed() {
    let gate = Gate(type: GateType.START_FINISH, splitNumber: 1,
      latitude: 37.452602, longitude: -122.207069, bearing: 32)
    let a = Point(latitude: 37.452414, longitude: -122.207193,
      speed: 14.210000038146973, bearing: 32.09501647949219,
      horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: 1)
    var b = Point(latitude: 37.452523, longitude: -122.207107,
      speed: 14.239999771118164, bearing: 32.09501647949219,
      horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: 2)
    b.lapDistance = 100.0
    b.lapTime = 0.1
    let c = Point(latitude: 37.45263, longitude: -122.207023,
      speed: 14.15999984741211, bearing: 32.09501647949219,
      horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: 3)
    var cross = Point()
    XCTAssertFalse(gate.crossed(start: a, destination: b, cross: &cross))
    XCTAssertFalse(gate.crossed(start: c, destination: b, cross: &cross))
    XCTAssertTrue(gate.crossed(start: b, destination: c, cross: &cross))
    XCTAssertTrue(cross.generated)
    XCTAssertEqual(cross.latitudeDegrees(), 37.452593)
    XCTAssertEqual(cross.longitudeDegrees(), -122.207052)
    XCTAssertEqualWithAccuracy(cross.speed, 14.18, 0.01)
    XCTAssertEqualWithAccuracy(cross.bearing, 31.93, 0.01)
    XCTAssertEqualWithAccuracy(cross.timestamp, 2.64915, 0.00001)
    XCTAssertEqualWithAccuracy(cross.lapDistance, b.lapDistance + b.distanceTo(cross), 0.01)
    XCTAssertEqualWithAccuracy(cross.lapTime, 0.74915, 0.00001)
    XCTAssertEqualWithAccuracy(cross.splitTime, 0.64915, 0.00001)
  }
  
}