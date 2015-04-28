//
//  ViewController.swift
//  J2ObjCSwift
//
//  Created by harry on 2/15/15.
//  Copyright (c) 2015 Harry Cheung. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  var points: [HCMPoint] = []
  var track: HCMTrack?
  
  @IBOutlet weak var label1000: UILabel!
  @IBOutlet weak var label10000: UILabel!

  override func viewDidLoad() {
    super.viewDidLoad()

    let trackJSON = ""
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
      +       "\"split_number\": \"3\","
      +       "\"gate_type\": \"START_FINISH\","
      +       "\"latitude\": \"37.452602\","
      +       "\"longitude\": \"-122.207069\","
      +       "\"bearing\": \"32\""
      +       "}"
      +     "]"
      +   "}"
      + "}"
    
    track = (HCMTrack_load__WithNSString_(trackJSON).objectAtIndex(0) as! HCMTrack)
    
    let lapsFilePath = NSBundle.mainBundle().pathForResource("multi_lap_session", ofType: "csv", inDirectory: "Data")!
    let contents = String(contentsOfFile: lapsFilePath, encoding: NSUTF8StringEncoding, error: nil)!
    let lines = contents.componentsSeparatedByString("\n")
    for line in lines {
      let parts = line.componentsSeparatedByString(",") as [NSString]
      points.append(HCMPoint(
            double: parts[0].doubleValue,
        withDouble: parts[1].doubleValue,
        withDouble: parts[2].doubleValue,
        withDouble: parts[3].doubleValue,
        withDouble: 5.0,
        withDouble: 15.0,
        withDouble: 0))
    }
  }

  @IBAction func run1000(sender: AnyObject) {
    label1000.text = (NSString(format: "%3f", run(1000)) as! String)
  }
  
  @IBAction func run10000(sender: AnyObject) {
    label10000.text = (NSString(format: "%3f", run(10000)) as! String)
  }
  
  func run(count: Int) -> Double {
    let start = NSDate().timeIntervalSince1970
    var startTime = start
    for index in 1...count {
      autoreleasepool {
        HCMSessionManager.getInstance().startSessionWithHCMTrack(track!)
        for point in points {
          HCMSessionManager.getInstance().gpsWithDouble(point.getLatitudeDegrees(),
            withDouble: point.getLongitudeDegrees(),
            withDouble: point.getSpeed(),
            withDouble: point.getBearing(),
            withDouble: point.getHorizontalAccuracy(),
            withDouble: point.getVerticalAccuracy(),
            withDouble: startTime)
          startTime += 1
        }
        HCMSessionManager.getInstance().endSession()
      }
    }
    return NSDate().timeIntervalSince1970 - start
  }

}

