//
//  Copyright (c) 2015 Harry Cheung
//

import UIKit
import XCTest

class PhysicsTests: XCTestCase {
  
  func testDistance() {
    XCTAssertEqual(Physics.distance(velocity: 0, acceleration: 0, time: 0), 0.0)
    XCTAssertEqual(Physics.distance(velocity: 1, acceleration: 1, time: 1), 1.5)
		XCTAssertEqual(Physics.distance(velocity: 2, acceleration: 2, time: 2), 8.0)
		XCTAssertEqual(Physics.distance(velocity: 3, acceleration: 0, time: 3), 9.0)
  }
  
  func testTime() {
    XCTAssertEqual(Physics.time(distance: 1.5, velocity: 1, acceleration: 1), 1.0)
		XCTAssertEqual(Physics.time(distance: 8.0, velocity: 2, acceleration: 2), 2.0)
		XCTAssertEqual(Physics.time(distance: 9.0, velocity: 3, acceleration: 0), 3.0)
  }

}
