//
//  Copyright (c) 2015 Harry Cheung
//

import UIKit
import XCTest

class SessionTests: XCTestCase {
  
  var track: Track?
  
  override func setUp() {
    if track == nil {
      let trackJSON = ""
        + "{"
        +   "\"track\": {"
        +     "\"id\": \"1000\","
        +     "\"name\": \"Test Raceway\","
        +     "\"gates\": ["
        +       "{"
        +       "\"type\": \"SPLIT\","
        +       "\"split_number\": \"1\","
        +       "\"latitude\": \"37.451775\","
        +       "\"longitude\": \"-122.203657\","
        +       "\"bearing\": \"136\""
        +       "},"
        +       "{"
        +       "\"type\": \"SPLIT\","
        +       "\"split_number\": \"2\","
        +       "\"latitude\": \"37.450127\","
        +       "\"longitude\": \"-122.205499\","
        +       "\"bearing\": \"326\""
        +       "},"
        +       "{"
        +       "\"split_number\": \"3\","
        +       "\"type\": \"START_FINISH\","
        +       "\"latitude\": \"37.452602\","
        +       "\"longitude\": \"-122.207069\","
        +       "\"bearing\": \"32\""
        +       "}"
        +     "]"
        +   "}"
        + "}"
      
      track = Track(jsonData: trackJSON.dataUsingEncoding(NSUTF8StringEncoding)!)
    }
  }
  
  func testSingleLapSession() {
    let lapsFilePath = NSBundle.mainBundle().pathForResource("single_lap_session", ofType: "csv", inDirectory: "Data")!
    let contents = String(contentsOfFile: lapsFilePath, encoding: NSUTF8StringEncoding, error: nil)!
    let lines = contents.componentsSeparatedByString("\n")
    
    var startTime = NSDate().timeIntervalSince1970
    SessionManager.instance.startSession(track!)
    let session = SessionManager.instance.session
    for line in lines {
      let parts = line.componentsSeparatedByString(",") as [NSString]
      SessionManager.instance.gps(
        latitude: parts[0].doubleValue,
        longitude: parts[1].doubleValue,
        speed: parts[2].doubleValue,
        bearing: parts[3].doubleValue,
        horizontalAccuracy: 5.0,
        verticalAccuracy: 15.0,
        timestamp: startTime)
      startTime += 1
    }
    SessionManager.instance.endSession()
    
    let laps = session!.laps
    XCTAssertEqual(laps.count, 3)
    XCTAssertFalse(laps[0].valid)
    XCTAssertTrue(laps[1].valid)
    XCTAssertFalse(laps[2].valid)
    XCTAssertEqual(laps[0].lapNumber, 0)
    XCTAssertEqual(laps[1].lapNumber, 1)
    XCTAssertEqual(laps[2].lapNumber, 2)
    XCTAssertEqualWithAccuracy(120.64222, laps[1].duration, 0.00001)
    XCTAssertEqualWithAccuracy(35.85215, laps[1].splits[0], 0.00001)
    XCTAssertEqualWithAccuracy(38.94201, laps[1].splits[1], 0.00001)
    XCTAssertEqualWithAccuracy(45.84806, laps[1].splits[2], 0.00001)
    XCTAssertEqualWithAccuracy(1298.63, laps[1].distance, 0.01)
  }
  
  func testMultiLapSession() {
    let lapsFilePath = NSBundle.mainBundle().pathForResource("multi_lap_session", ofType: "csv", inDirectory: "Data")!
    let contents = String(contentsOfFile: lapsFilePath, encoding: NSUTF8StringEncoding, error: nil)!
    let lines = contents.componentsSeparatedByString("\n")
    
    var startTime = NSDate().timeIntervalSince1970
    SessionManager.instance.startSession(track!)
    let session = SessionManager.instance.session
    for line in lines {
      let parts = line.componentsSeparatedByString(",") as [NSString]
      SessionManager.instance.gps(
        latitude: parts[0].doubleValue,
        longitude: parts[1].doubleValue,
        speed: parts[2].doubleValue,
        bearing: parts[3].doubleValue,
        horizontalAccuracy: 5.0,
        verticalAccuracy: 15.0,
        timestamp: startTime)
      startTime += 1
    }
    SessionManager.instance.endSession()
    
    let laps = session!.laps
    XCTAssertEqual(laps.count, 6)
    XCTAssertFalse(laps[0].valid)
    XCTAssertTrue(laps[1].valid)
    XCTAssertTrue(laps[2].valid)
    XCTAssertTrue(laps[3].valid)
    XCTAssertTrue(laps[4].valid)
    XCTAssertFalse(laps[5].valid)
    XCTAssertEqual(laps[0].lapNumber, 0)
    XCTAssertEqual(laps[1].lapNumber, 1)
    XCTAssertEqual(laps[2].lapNumber, 2)
    XCTAssertEqual(laps[3].lapNumber, 3)
    XCTAssertEqual(laps[4].lapNumber, 4)
    XCTAssertEqual(laps[5].lapNumber, 5)
    XCTAssertEqualWithAccuracy(120.64222, laps[1].duration, 0.00001)
    XCTAssertEqualWithAccuracy(100.01685, laps[2].duration, 0.00001)
    XCTAssertEqualWithAccuracy( 96.74609, laps[3].duration, 0.00001)
    XCTAssertEqualWithAccuracy( 94.61198, laps[4].duration, 0.00001)
    XCTAssertEqualWithAccuracy(1298.63, laps[1].distance, 0.01)
    XCTAssertEqualWithAccuracy(1298.69, laps[2].distance, 0.01)
    XCTAssertEqualWithAccuracy(1306.85, laps[3].distance, 0.01)
    XCTAssertEqualWithAccuracy(1306.55, laps[4].distance, 0.01)
  }
}