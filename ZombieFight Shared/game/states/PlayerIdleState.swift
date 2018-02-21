//
//  PlayerIdleState.swift
//  ZombieFight
//
//  Created by Vivek Nagar on 2/21/18.
//  Copyright © 2018 Vivek Nagar. All rights reserved.
//

import SceneKit

class PlayerIdleState : PlayerState {
    
    override init() {
        super.init()
        
    }
    
    override func onEnterState() {
        super.onEnterState()
        print("Entering Zombie Idle State")
        
        if let sm = self.stateMachine, let owner = sm.getOwner() as? PlayerEntity  {
            owner.changeAnimationStateTo(newState: .Idle)
        }
    }
    override func onExitState() {}
    
    override func getStateType() -> PlayerStateType { return PlayerStateType.Idle }
    
    override func onUpdate(time:GameTime) -> PlayerStateType {
        if let sm = self.stateMachine, let owner = sm.getOwner() as? PlayerEntity {
            if (owner.getVelocity() != SCNVector3Zero) {
                return .Walk
            }
        }
        return .Idle
    }
}
