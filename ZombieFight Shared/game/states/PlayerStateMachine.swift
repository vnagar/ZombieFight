//
//  PlayerStateMachine.swift
//  ZombieFight
//
//  Created by Vivek Nagar on 2/21/18.
//  Copyright © 2018 Vivek Nagar. All rights reserved.
//

import Foundation

class PlayerStateMachine {
    private var owner:Entity?
    private var currentState:PlayerState?
    private var currentStateType = PlayerStateType.Idle
    private var states = [PlayerStateType:PlayerState]()
    
    init(owner:Entity, stateList:[PlayerState]) {
        self.owner = owner
        for state in stateList {
            if let val = states[state.getStateType()] {
                print("State already exists ... \(val)")
            } else {
                states[state.getStateType()] = state
                state.setStateMachine(stateMachine: self)
            }
        }
        currentState = states[currentStateType]
        currentState?.onEnterState()
    }
    
    func getOwner() -> Entity? {
        return self.owner
    }
    
    func preupdate(time:GameTime) {
    }
    
    func update(time:GameTime) {
        if let curState = currentState {
            let newStateType = curState.onUpdate(time:time)
            if newStateType != currentStateType {
                if let newState = states[newStateType] {
                    currentState?.onExitState()
                    newState.onEnterState()
                    currentState = newState
                } else {
                    print("Invalid state returned from current state's onUpdate method, default to idle")
                    if let newState = states[.Idle] {
                        currentState?.onExitState()
                        newState.onEnterState()
                        currentState = newState
                    }
                }
                currentStateType = newStateType
            }
        }
    }
}
