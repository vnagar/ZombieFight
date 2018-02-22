//
//  PlayerWalkState.swift
//  ZombieFight
//
//  Created by Vivek Nagar on 2/21/18.
//  Copyright © 2018 Vivek Nagar. All rights reserved.
//

import SceneKit

class PlayerWalkState : PlayerState {
    
    override init() {
        super.init()
        
    }
    
    override func onEnterState() {
        print("Entering WALK STATE")
        if let sm = self.stateMachine, let owner = sm.getOwner() as? PlayerEntity {
            owner.changeAnimationStateTo(newState: .Walk)
        }
    }
    
    override func onExitState() {}
    override func getStateType() -> PlayerStateType { return PlayerStateType.Walk }
    override func onUpdate(time:GameTime) -> PlayerStateType {
        if let sm = self.stateMachine, let owner = sm.getOwner() as? PlayerEntity {
            if (owner.getVelocity() == SCNVector3Zero) {
                return .Idle
            }
        }
        return .Walk
    }
}
