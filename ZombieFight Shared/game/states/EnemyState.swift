//
//  EnemyState.swift
//  ZombieFight
//
//  Created by Vivek Nagar on 2/21/18.
//  Copyright © 2018 Vivek Nagar. All rights reserved.
//

import SceneKit

class EnemyState {
    var stateMachine:EnemyStateMachine?
    
    init() {
    }
    
    /* Called by EnemyStateMachine when adding states to itself */
    func setStateMachine(stateMachine:EnemyStateMachine) {
        self.stateMachine = stateMachine
    }
    
    //Default handlers
    func onEnterState() {}
    func onExitState() {}
    func getStateType() -> EnemyStateType { return EnemyStateType.None}
    func onUpdate(time:GameTime) -> EnemyStateType {return EnemyStateType.None}
    
    func onTriggerEvent(eventType:AITriggerEventType, collider:SCNNode, matchingCollider:SCNNode) {
        //called when collisions happen, evaluate threats
        if let sm = self.stateMachine, let _ = sm.getOwner() as? EnemyEntity {
            if(eventType != .Exit) {
                if((collider.name == "Player") && matchingCollider.physicsBody!.categoryBitMask == ColliderType.Enemy.rawValue) {
                    sm.isInAttackRange = true
                }
            
            } else {
                if(collider.name == "Player"  && matchingCollider.physicsBody!.categoryBitMask == ColliderType.Enemy.rawValue) {
                    sm.isInAttackRange = false
                }
            }
        }
    }
    
    func onDestinationReached(isReached:Bool) { }

}
