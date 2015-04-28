//
//  Copyright (c) 2015 Harry Cheung
//
import UIKit
import XCTest

class TrackTests: XCTestCase {
  
  func testTrackLoadFromJSON() {
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
    
    let track = Track(jsonData: trackJSON.dataUsingEncoding(NSUTF8StringEncoding)!)
    
    XCTAssertEqual(track.id, 1000)
    XCTAssertEqual(track.name, "Test Raceway")
    XCTAssertEqual(track.numSplits(), 3)
  }
  
  func testTrackLoadFailOnId() {
    let trackJSON = ""
      + "{"
      +   "\"track\": {"
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
      +       "\"type\": \"START_FINISH\","
      +       "\"split_number\": \"3\","
      +       "\"latitude\": \"37.452602\","
      +       "\"longitude\": \"-122.207069\","
      +       "\"bearing\": \"32\""
      +       "}"
      +     "]"
      +   "}"
      + "}"
    
    //XCTAssertThrows(Track(jsonData: trackJSON.dataUsingEncoding(NSUTF8StringEncoding)!))
  }
}