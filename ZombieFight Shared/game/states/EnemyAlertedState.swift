//
//  EnemyWalkState.swift
//  ZombieFight
//
//  Created by Vivek Nagar on 2/21/18.
//  Copyright © 2018 Vivek Nagar. All rights reserved.
//

import SceneKit

class EnemyAlertedState : EnemyState {
    
    override init() {
        super.init()
        
    }
    
    override func onEnterState() {
        if let sm = self.stateMachine, let owner = sm.getOwner() as? EnemyEntity {
            owner.changeAnimationStateTo(newState: .Alert)
        }
    }
    
    override func onExitState() {}
    override func getStateType() -> EnemyStateType { return EnemyStateType.Alerted }
    override func onUpdate(time:GameTime) -> EnemyStateType {
        if let sm = self.stateMachine, let _ = sm.getOwner() as? EnemyEntity {
        }
        return .Alerted
    }
}
