//
//  StateMachine.swift
//  ZombieFight
//
//  Created by Vivek Nagar on 2/21/18.
//  Copyright © 2018 Vivek Nagar. All rights reserved.
//

import Foundation

class PlayerStateMachine {
    private var owner:Entity?
    private var states = [State]()
    
    init(stateList:[State]) {
        self.states = stateList
        
        for state in stateList {
            if let val = states[state.getStateType()] {
                print("Value already exists ... \(val)")
            } else {
                states[state.getStateType()] = state
                state.setStateMachine(stateMachine: self)
            }
        }
        currentState = states[currentStateType]
        currentState?.onEnterState()
    }
    
    func setOwner(owner:Entity) {
        self.owner = owner
    }
}
