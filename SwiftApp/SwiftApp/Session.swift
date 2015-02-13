//
//  Copyright (c) 2015 Harry Cheung
//

import UIKit

class Session: NSObject {
    
    weak var track:     Track?
    let startTime: Double
    var duration:  Double = 0
    var laps:      [Lap] = []
    var bestLap:   Lap?
    
    init(track: Track, startTime: Double) {
        self.track     = track
        self.startTime = startTime
        super.init()
    }
    
    convenience init(track: Track) {
        self.init(track: track, startTime: NSDate().timeIntervalSince1970)
    }
    
    func tick(currentTime: Double) {
        duration = currentTime - startTime
    }
}