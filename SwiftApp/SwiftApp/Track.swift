//
//  Copyright (c) 2015 Harry Cheung
//

import UIKit

final class Track {
  
  var gates: [Gate] = []
  let id: Int!
  let name: String!
  var start: Gate!
  
  init(jsonObject: NSDictionary) {
    let jsonTrack = jsonObject["track"] as! NSDictionary
    let jsonGates = jsonTrack["gates"] as! NSArray
    for i in 0..<jsonGates.count {
      let jsonGate = jsonGates[i] as! NSDictionary
      let gate = Gate(
        type:        GateType(rawValue: jsonGate["type"] as! String)!,
        splitNumber: jsonGate["split_number"]!.integerValue,
        latitude:    jsonGate["latitude"]!.doubleValue,
        longitude:   jsonGate["longitude"]!.doubleValue,
        bearing:     jsonGate["bearing"]!.doubleValue)
      if gate.type == GateType.START_FINISH ||
        gate.type == GateType.START {
          start = gate
      }
      gates.append(gate)
    }
    id   = jsonTrack["id"]?.integerValue
    name = jsonTrack["name"] as! String
    
    assert(id != nil)
    assert(name != nil)
    assert(start != nil)
  }
  
  convenience init(jsonData: NSData) {
    let jsonObject = NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
    self.init(jsonObject: jsonObject)
  }
  
  convenience init(file filePath: String) {
    var error:NSError?
    var content = NSData(contentsOfFile: filePath)
    // TODO: do something with error
    self.init(jsonData: content!)
  }
  
  func numSplits() -> Int {
    return gates.count
  }
  
  func distanceToStart(#latitude: Double, longitude: Double) -> Double {
    return start.location.distanceTo(Point(latitude: latitude, longitude: longitude));
  }
}
