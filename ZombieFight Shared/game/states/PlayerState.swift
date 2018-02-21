//
//  PlayerState.swift
//  ZombieFight
//
//  Created by Vivek Nagar on 2/21/18.
//  Copyright © 2018 Vivek Nagar. All rights reserved.
//

import Foundation

class PlayerState {
    var stateMachine:PlayerStateMachine?
    
    init() {
    }
    
    /* Called by PlayerStateMachine when adding states to itself */
    func setStateMachine(stateMachine:PlayerStateMachine) {
        self.stateMachine = stateMachine
    }
    
    //Default handlers
    func onEnterState() {}
    func onExitState() {}
    func getStateType() -> PlayerStateType { return PlayerStateType.None}
    func onUpdate(time:GameTime) -> PlayerStateType {return PlayerStateType.None}
    
}
