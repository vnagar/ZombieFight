//
//  PlayerWalkState.swift
//  ZombieFight
//
//  Created by Vivek Nagar on 2/21/18.
//  Copyright © 2018 Vivek Nagar. All rights reserved.
//

import Foundation

class PlayerWalkState : PlayerState {
    
    override init() {
        super.init()
        
    }
    
    override func onEnterState() {
        if let sm = self.stateMachine {
            if let owner = sm.getOwner() as? PlayerEntity {
                owner.changeAnimationStateTo(newState: .Walk)
            }
        }
    }
    override func onExitState() {}
    override func getStateType() -> PlayerStateType { return PlayerStateType.Walk }
    override func onUpdate(time:GameTime) -> PlayerStateType {
        return PlayerStateType.Walk
    }
}
