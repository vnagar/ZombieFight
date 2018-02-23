//
//  EnemyPatrolState.swift
//  ZombieFight
//
//  Created by Vivek Nagar on 2/22/18.
//  Copyright © 2018 Vivek Nagar. All rights reserved.
//

import SceneKit

class EnemyPatrolState : EnemyState {
    
    override init() {
        super.init()
        
    }
    
    override func onEnterState() {
        print("Entering Patrol state")
        if let sm = self.stateMachine, let owner = sm.getOwner() as? EnemyEntity {
            owner.changeAnimationStateTo(newState: .Walk)
        }
    }
    
    override func onExitState() {}
    
    override func getStateType() -> EnemyStateType { return .Patrol }
    
    override func onUpdate(time:GameTime) -> EnemyStateType {
        if let sm = self.stateMachine, let owner = sm.getOwner() as? EnemyEntity {
            owner.setDestination(targetPosition: SCNVector3(-6.0, 0.0, 4.0))
        }
        return .Patrol
    }
}
