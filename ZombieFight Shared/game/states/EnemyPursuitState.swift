//
//  EnemyPursuitState.swift
//  ZombieFight
//
//  Created by Vivek Nagar on 2/23/18.
//  Copyright © 2018 Vivek Nagar. All rights reserved.
//

import SceneKit

class EnemyPursuitState : EnemyState {
    private var timer = 0.0
    
    override init() {
        super.init()
    }
    
    override func onEnterState() {
        super.onEnterState()
        print("Entering Enemy Pursuit State")
        timer = 0.0
        
        if let sm = self.stateMachine, let owner = sm.getOwner() as? EnemyEntity  {
            owner.changeAnimationStateTo(newState: .Run)
            owner.setDestination(targetPosition: sm.target.position)
        }
    }
    override func onExitState() {}
    
    override func getStateType() -> EnemyStateType { return EnemyStateType.Pursuit }
    
    override func onUpdate(time:GameTime) -> EnemyStateType {
        guard let sm = self.stateMachine, let _ = sm.getOwner() as? EnemyEntity  else { return .None }
        if(sm.isInAttackRange) {
            return .Attack
        }
        return .Pursuit
    }
}
