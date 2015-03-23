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
    
    track = HCMTrack(data: trackJSON.dataUsingEncoding(NSUTF8StringEncoding))
    
    let lapsFilePath = NSBundle.mainBundle().pathForResource("multi_lap_session", ofType: "csv", inDirectory: "Data")!
    let contents = String(contentsOfFile: lapsFilePath, encoding: NSUTF8StringEncoding, error: nil)!
    let lines = contents.componentsSeparatedByString("\n")
    for line in lines {
      let parts = line.componentsSeparatedByString(",") as [NSString]
      points.append(HCMPoint(latitude: parts[0].doubleValue,
        longitude: parts[1].doubleValue,
        speed: parts[2].doubleValue,
        bearing: parts[3].doubleValue,
        horizontalAccuracy: 5.0,
        verticalAccuracy: 15.0,
        timestamp: 0))
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
        HCMSessionManager.instance().startSessionWithTrack(track!)
        for point in points {
          HCMSessionManager.instance().gpsWithLatitude(point.latitudeDegrees(),
            longitude: point.longitudeDegrees(),
            speed: point.speed(),
            bearing: point.bearing(),
            horizontalAccuracy: point.hAccuracy(),
            verticalAccuracy: point.vAccuracy(),
            timestamp: startTime)
          startTime += 1
        }
        HCMSessionManager.instance().endSession()
      }
    }
    return NSDate().timeIntervalSince1970 - start
  }

}

