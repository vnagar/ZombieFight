//
//  EnemyStateMachine.swift
//  ZombieFight
//
//  Created by Vivek Nagar on 2/21/18.
//  Copyright © 2018 Vivek Nagar. All rights reserved.
//

import SceneKit

enum AITriggerEventType : Int {
    case Enter = 0, Stay, Exit
}

class EnemyStateMachine {
    private var owner:Entity?
    private var currentState:EnemyState?
    private var currentStateType = EnemyStateType.Idle
    private var states = [EnemyStateType:EnemyState]()
    
    var visualThreat = EnemyTarget()
    var audioThreat = EnemyTarget()
    var target = EnemyTarget()
    private var destinationCloseLimit = Float(0.1)
    var reachedTarget = false
    var isInAttackRange = false
    
    init(owner:Entity, stateList:[EnemyState]) {
        self.owner = owner
        for state in stateList {
            if let _ = states[state.getStateType()] {
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
    
    func setTarget(t:EnemyTargetType, c:SCNNode?, p:SCNVector3, d:Float) {
        target.setTarget(t: t, c: c, p: p, d: d)
    }
    
    
    func setTarget(t:EnemyTarget) {
        target.setTarget(t:t.type, c:t.collider, p:t.position, d:t.distance)
    }
    
    
    func clearTarget() {
        target.clear()
        // Also disable target collider
    }
    
    func onTriggerEvent(eventType:AITriggerEventType, collider:SCNNode, matchingCollider:SCNNode) {
        // called when collisions happen, let the state evaluate the threats
        currentState?.onTriggerEvent(eventType: eventType, collider: collider, matchingCollider:matchingCollider)
    }
    
    func preupdate(time:GameTime) {
        visualThreat.clear()
        audioThreat.clear()
    }
    
    func update(time:GameTime) {
        if(target.type != EnemyTargetType.None) {
            target.distance = (owner!.getNode().position - target.position).length()
            if(target.distance < destinationCloseLimit) {
                reachedTarget = true
                currentState?.onDestinationReached(isReached: true)
            }
        }
        
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
