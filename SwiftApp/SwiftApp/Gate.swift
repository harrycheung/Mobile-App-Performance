//
//  Copyright (c) 2015 Harry Cheung
//

import UIKit

enum GateType: String, Printable {
  case SPLIT = "SPLIT", START = "START", FINISH = "FINISH", START_FINISH = "START_FINISH"
  
  var description : String {
    switch self {
    case .SPLIT: return "SPLIT"
    case .START: return "START"
    case .FINISH: return "FINISH"
    case .START_FINISH: return "START_FINISH"
    }
  }
}


final class Gate {
  
  let LINE_WIDTH:    Double = 30
  let BEARING_RANGE: Double = 5
  var location: Point
  let type: GateType
  let splitNumber: Int
  var leftPoint, rightPoint: Point?
  
  init(type: GateType, splitNumber: Int, latitude: Double, longitude: Double, bearing: Double) {
    self.type = type
    self.splitNumber = splitNumber
    self.location = Point(latitude: latitude, longitude: longitude, inRadians: false)
    let leftBearing  = bearing - 90 < 0 ? bearing + 270 : bearing - 90
    let rightBearing = bearing + 90 > 360 ? bearing - 270 : bearing + 90
    self.leftPoint  = location.destination(leftBearing, distance: LINE_WIDTH / 2)
    self.rightPoint = location.destination(rightBearing, distance: LINE_WIDTH / 2)
    self.location.bearing = bearing
  }
  
  func crossed(#start: Point, destination: Point, inout cross: Point) -> Bool {
    let pathBearing = start.bearingTo(destination)
    if pathBearing > (location.bearing - BEARING_RANGE) &&
      pathBearing < (location.bearing + BEARING_RANGE) {
      if Point.intersectSimple(p: leftPoint!, p2: rightPoint!, q: start, q2: destination, intersection: &cross) {
        let distance     = start.distanceTo(cross)
        let timeSince    = destination.timestamp - start.timestamp
        let acceleration = (destination.speed - start.speed) / timeSince
        let timeCross    = Physics.time(distance: distance, velocity: start.speed, acceleration: acceleration)
        cross.generated   = true
        cross.speed       = start.speed + acceleration * timeCross
        cross.bearing     = start.bearingTo(destination)
        cross.timestamp   = start.timestamp + timeCross
        cross.lapDistance = start.lapDistance + distance
        cross.lapTime     = start.lapTime + timeCross
        cross.splitTime   = start.splitTime + timeCross
        return true
      }
    }
    return false
  }
}
