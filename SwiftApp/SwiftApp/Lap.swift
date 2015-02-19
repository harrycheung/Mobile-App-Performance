//
//  Copyright (c) 2015 Harry Cheung
//

import UIKit

final class Lap: NSObject {
  
  let GATE_RANGE: Double = 100
  
  weak var session:  Session?
  weak var track:    Track?
  var duration: Double
  var distance: Double
  var valid:    Bool
  let startTime: Double
  let lapNumber: Int
  var points:   [Point]
  let outLap:   Bool
  var splits:   [Double]
  
  init(session: Session, track: Track, startTime: Double, lapNumber: Int) {
    self.session   = session
    self.track     = track
    self.startTime = startTime
    self.lapNumber = lapNumber
    self.points    = []
    self.duration  = 0
    self.distance  = 0
    self.valid     = false
    self.outLap    = lapNumber == 0
    self.splits    = [Double](count: track.numSplits(), repeatedValue: 0)
  }
  
  func add(point: Point) {
    duration = point.lapTime
    distance = point.lapDistance
    points.append(point)
  }
  
}