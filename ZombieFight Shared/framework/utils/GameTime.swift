//
//  GameTime.swift
//  ZombieFight
//
//  Created by Vivek Nagar on 2/20/18.
//  Copyright © 2018 Vivek Nagar. All rights reserved.
//

import Foundation

class GameTime {
    var deltaTime:TimeInterval = 0.0
    var currentTime:TimeInterval = 0.0
    
    init() {
    }
    
    func update(time: TimeInterval) {
        if(currentTime == 0.0) {
            currentTime = time
        }
        deltaTime = time - currentTime
        currentTime = time
    }
    
    class func getSystemTime() -> TimeInterval {
        return TimeInterval(NSDate().timeIntervalSince1970)
    }
}
