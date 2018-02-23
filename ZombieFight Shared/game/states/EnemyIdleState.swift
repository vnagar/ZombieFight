//
//  EnemyIdleState.swift
//  ZombieFight
//
//  Created by Vivek Nagar on 2/21/18.
//  Copyright © 2018 Vivek Nagar. All rights reserved.
//

import SceneKit

class EnemyIdleState : EnemyState {
    private var idleTime = 5.0
    private var timer = 0.0
    
    override init() {
        super.init()
        
    }
    
    override func onEnterState() {
        super.onEnterState()
        //print("Entering Enemy Idle State")
        timer = 0.0

        
        if let sm = self.stateMachine, let owner = sm.getOwner() as? EnemyEntity  {
            owner.changeAnimationStateTo(newState: .Idle)
        }
    }
    override func onExitState() {}
    
    override func getStateType() -> EnemyStateType { return EnemyStateType.Idle }
    
    override func onUpdate(time:GameTime) -> EnemyStateType {
        if let sm = self.stateMachine, let owner = sm.getOwner() as? EnemyEntity {
            
        }
        timer = timer + time.deltaTime
        if (timer < idleTime) {
            return .Idle
        } else {
            return .Patrol
        }
    }
}
