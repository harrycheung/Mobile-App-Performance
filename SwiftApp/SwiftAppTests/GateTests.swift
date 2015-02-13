//
//  Copyright (c) 2015 Harry Cheung
//

import UIKit
import XCTest

class GateTests: XCTestCase {
  
  func testCrossed() {
    let g = Gate(type: GateType.START_FINISH, splitNumber: 1, latitude: 37.452602, longitude: -122.207069, bearing: 32);
    let a = Point(latitude: 37.452376,longitude: -122.207223, bearing: 39);
    let b = Point(latitude: 37.452482,longitude: -122.207139, bearing: 37);
    let c = Point(latitude: 37.452698,longitude: -122.206969, bearing: 44);
    
    XCTAssertNil(g.crossed(start: a, destination: b))
    XCTAssertNil(g.crossed(start: c, destination: b))
    XCTAssertEqual(g.crossed(start: b, destination: c)!, Point(latitude: 37.452593,longitude: -122.207051))
  }
  
}