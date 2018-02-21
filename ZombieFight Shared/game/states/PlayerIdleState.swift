//
//  PlayerIdleState.swift
//  ZombieFight
//
//  Created by Vivek Nagar on 2/21/18.
//  Copyright © 2018 Vivek Nagar. All rights reserved.
//

import Foundation

class PlayerIdleState : PlayerState {
    private var idleTime = 5.0
    private var timer = 0.0
    
    override init() {
        super.init()
        
    }
    
    override func onEnterState() {
        super.onEnterState()
        print("Entering Zombie Idle State")
        timer = 0.0
        
        if let sm = self.stateMachine {
            if let owner = sm.getOwner() as? PlayerEntity {
                owner.changeAnimationStateTo(newState: .Idle)
            }
        }
    }
    override func onExitState() {}
    
    override func getStateType() -> PlayerStateType { return PlayerStateType.Idle }
    
    override func onUpdate(time:GameTime) -> PlayerStateType {
        timer = timer + time.deltaTime
        if (timer < idleTime) {
            return .Idle
        } else {
            return .Walk
        }
    }
}
