//
//  EnemyPatrolState.swift
//  ZombieFight
//
//  Created by Vivek Nagar on 2/22/18.
//  Copyright © 2018 Vivek Nagar. All rights reserved.
//

import SceneKit

class EnemyPatrolState : EnemyState {
    
    private var patrolPoints = [SCNVector3(-5.0, 0.0, -2.0), SCNVector3(0.0, 0.0, 0.0), SCNVector3(6.0, 0.0, 5.0), SCNVector3(7.0, 0.0, 4.0)]
    private var waypointNetwork = AIWaypointNetwork()
    private var currentWaypoint = SCNVector3Zero
    
    override init() {
        super.init()
        
    }
    
    override func onEnterState() {
        print("Entering Patrol state")
        if let sm = self.stateMachine, let owner = sm.getOwner() as? EnemyEntity {
            if(sm.target.type != EnemyTargetType.Waypoint) {
                sm.clearTarget()
            }
            waypointNetwork = AIWaypointNetwork(nodes:patrolPoints)
            currentWaypoint = waypointNetwork.getNextWaypoint()
            sm.setTarget(t: .Waypoint, c: nil, p: currentWaypoint, d: (owner.getNode().position - currentWaypoint).length())
            owner.setDestination(targetPosition: currentWaypoint)
            owner.changeAnimationStateTo(newState: .Walk)
        }
    }
    
    override func onDestinationReached(isReached: Bool) {
        if(isReached == true) {
            if let sm = self.stateMachine, let owner = sm.getOwner() as? EnemyEntity {
                if(sm.target.type == .Waypoint) {
                    owner.changeAnimationStateTo(newState: .Walk)
                    currentWaypoint = waypointNetwork.getNextWaypoint()
                    sm.setTarget(t: .Waypoint, c: nil, p: currentWaypoint, d: (owner.getNode().position - currentWaypoint).length())
                    owner.setDestination(targetPosition: currentWaypoint)
                }
            }
        }
    }
    
    override func onExitState() {}
    
    override func getStateType() -> EnemyStateType { return .Patrol }
    
    override func onUpdate(time:GameTime) -> EnemyStateType {
        if let sm = self.stateMachine, let owner = sm.getOwner() as? EnemyEntity {
            if(sm.isInAttackRange) {
                return .Attack
            }
        }
        return .Patrol
    }
}
