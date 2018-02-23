//
//  AIWaypointNetwork.swift
//  ZombieWar
//
//  Created by Vivek Nagar on 2/19/18.
//  Copyright © 2018 Vivek Nagar. All rights reserved.
//

import SceneKit

class AIWaypointNetwork {
    private var waypoints = [SCNVector3]()
    var currentIndex = 0
    
    init() {
        
    }
    
    init(nodes:[SCNVector3]) {
        self.waypoints = nodes
    }
    
    func getNextWaypoint() -> SCNVector3 {
        if currentIndex == waypoints.count {
            currentIndex = 0
        }
        let waypoint = waypoints[currentIndex]
        currentIndex = currentIndex + 1
        return waypoint
    }
}
