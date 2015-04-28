//
//  Copyright (c) 2015 Harry Cheung
//

import UIKit

func toRadians(value: Double) -> Double {
  return value * M_PI / 180.0
}

func toDegrees(value: Double) -> Double {
  return value * 180.0 / M_PI
}

func == (left: Point, right: Point) -> Bool {
  return (left.latitudeDegrees() == right.latitudeDegrees()) && (left.longitudeDegrees() == right.longitudeDegrees())
}


struct Point: Equatable {
  
  let RADIUS: Double = 6371000
  
  var latitude: Double
  var longitude: Double
  var speed: Double
  var bearing: Double
  var hAccuracy: Double
  var vAccuracy: Double
  var timestamp: Double
  var lapDistance: Double
  var lapTime: Double
  var splitTime: Double
  var acceleration: Double
  var generated: Bool = false
  
  init() {
    self.init(latitude: 0, longitude: 0, inRadians: false)
  }
  
  init (latitude: Double, longitude: Double, inRadians: Bool) {
    if inRadians {
      self.latitude  = latitude
      self.longitude = longitude
    } else {
      self.latitude  = toRadians(latitude)
      self.longitude = toRadians(longitude)
    }
    self.speed        = 0
    self.bearing      = 0
    self.hAccuracy    = 0
    self.vAccuracy    = 0
    self.timestamp    = 0
    self.lapDistance  = 0
    self.lapTime      = 0
    self.splitTime    = 0
    self.acceleration = 0
  }
  
   init (latitude: Double, longitude: Double) {
    self.init(latitude: latitude, longitude: longitude, inRadians: false)
  }
  
   init (latitude: Double, longitude: Double, bearing: Double) {
    self.init(latitude: latitude, longitude: longitude, inRadians: false)
    self.bearing = bearing
  }
  
   init (latitude: Double, longitude: Double, speed: Double, bearing: Double,
    horizontalAccuracy: Double, verticalAccuracy: Double, timestamp: Double) {
      self.init(latitude: latitude, longitude: longitude, inRadians: false)
      self.speed     = speed
      self.bearing   = bearing
      self.hAccuracy = horizontalAccuracy
      self.vAccuracy = verticalAccuracy
      self.timestamp = timestamp
  }
  
  mutating func setLapTime(startTime: Double, splitStartTime: Double) {
    lapTime = timestamp - startTime
    splitTime = timestamp - splitStartTime
  }
  
  func roundValue(value: Double) -> Double {
    return round(value * 1000000.0) / 1000000.0
  }
  
  func latitudeDegrees() -> Double {
    return roundValue(toDegrees(latitude))
  }
  
  func longitudeDegrees() -> Double {
    return roundValue(toDegrees(longitude))
  }
  
  func subtract(point: Point) -> Point {
    return Point(latitude: latitude - point.latitude, longitude: longitude - point.longitude, inRadians: true)
  }
  
  func bearingTo(point: Point, inRadians: Bool) -> Double {
    let φ1 = latitude
    let φ2 = point.latitude
    let Δλ = point.longitude - longitude
    
    let y = sin(Δλ) * cos(φ2)
    let x = cos(φ1) * sin(φ2) - sin(φ1) * cos(φ2) * cos(Δλ)
    let θ = atan2(y, x)
    
    if (inRadians) {
      return roundValue((θ + 2 * M_PI) % M_PI)
    } else {
      return roundValue((toDegrees(θ) + 2 * 360) % 360)
    }
  }
  
  func bearingTo(point: Point) -> Double {
    return bearingTo(point, inRadians: false)
  }
  
  func destination(bearing: Double, distance: Double) -> Point {
    let θ  = toRadians(bearing)
    let δ  = distance / RADIUS
    let φ1 = latitude
    let λ1 = longitude
    let φ2 = asin(sin(φ1) * cos(δ) + cos(φ1) * sin(δ) * cos(θ))
    var λ2 = λ1 + atan2(sin(θ) * sin(δ) * cos(φ1), cos(δ) - sin(φ1) * sin(φ2))
    λ2 = (λ2 + 3.0 * M_PI) % (2.0 * M_PI) - M_PI // normalise to -180..+180
    
    return Point(latitude: φ2, longitude: λ2, inRadians: true)
  }
  
  func distanceTo(point: Point) -> Double {
    let φ1 = latitude
    let λ1 = longitude
    let φ2 = point.latitude
    let λ2 = point.longitude
    let Δφ = φ2 - φ1
    let Δλ = λ2 - λ1
    
    let a = sin(Δφ / 2) * sin(Δφ / 2) + cos(φ1) * cos(φ2) * sin(Δλ / 2) * sin(Δλ / 2)
    
    return RADIUS * 2 * atan2(sqrt(a), sqrt(1 - a))
  }
  
  static func intersectSimple(#p: Point, p2: Point, q: Point, q2: Point, inout intersection: Point) -> Bool {
    let s1_x = p2.longitude - p.longitude
    let s1_y = p2.latitude - p.latitude
    let s2_x = q2.longitude - q.longitude
    let s2_y = q2.latitude - q.latitude
    
    let den = (-s2_x * s1_y + s1_x * s2_y)
    if den == 0 { return false }
    
    let s = (-s1_y * (p.longitude - q.longitude) + s1_x * (p.latitude - q.latitude)) / den
    let t = ( s2_x * (p.latitude - q.latitude) - s2_y * (p.longitude - q.longitude)) / den
    
    if s >= 0 && s <= 1 && t >= 0 && t <= 1 {
      intersection.latitude = p.latitude + (t * s1_y)
      intersection.longitude = p.longitude + (t * s1_x)
      return true
    }
    
    return false
  }
  
}
