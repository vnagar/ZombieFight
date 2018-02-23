//
//  EnemyAttackState.swift
//  ZombieFight
//
//  Created by Vivek Nagar on 2/22/18.
//  Copyright © 2018 Vivek Nagar. All rights reserved.
//

import SceneKit

class EnemyAttackState : EnemyState {
    
    override init() {
        super.init()
        
    }
    
    override func onEnterState() {
        print("Entering Attack state")
        if let sm = self.stateMachine, let owner = sm.getOwner() as? EnemyEntity {
            owner.changeAnimationStateTo(newState: .Attack)
        }
    }
    
    override func onExitState() {
    }
    
    override func getStateType() -> EnemyStateType { return .Attack }
    
    override func onUpdate(time:GameTime) -> EnemyStateType {
        if let sm = self.stateMachine, let _ = sm.getOwner() as? EnemyEntity {
            if(sm.isInAttackRange) {
                return .Attack
            } else {
                return .Patrol
            }
        }
        return .Attack
    }
}
