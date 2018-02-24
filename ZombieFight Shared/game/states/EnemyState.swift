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
        //called when collisions happen, set visual and audio threats that can then be evaluated by individual states
        if let sm = self.stateMachine, let owner = sm.getOwner() as? EnemyEntity {
            if(eventType != .Exit) {
                let currentVisualThreatType = sm.visualThreat.type
                if((collider.name == "Player") && matchingCollider.physicsBody!.categoryBitMask == ColliderType.Enemy.rawValue) {
                    //case when player's physics body and enemy's physics body collide
                    //check if the player has snuck behind the enemy
                    if(isColliderVisible(collider)) {
                        sm.isInAttackRange = true
                    }
                }
                if ((collider.name == "Player") && matchingCollider.physicsBody!.categoryBitMask == ColliderType.EnemySensor.rawValue) {
                    // Sensor collided with player - highest priority threat
                    let distance = (owner.getNode().position - collider.getWorldPosition()).length()
                    if((currentVisualThreatType != .Visual_Player) || (currentVisualThreatType == .Visual_Player && distance < sm.visualThreat.distance) ) {
                        if isColliderVisible(collider) {
                            print("Player is in FOV")
                            //it is close and in our FOV, so store it as the most dangerous target
                            sm.visualThreat.setTarget(t: .Visual_Player, c: collider, p: collider.getWorldPosition(), d: distance)
                        }
                    }
                }
            
            } else {
                if(collider.name == "Player"  && matchingCollider.physicsBody!.categoryBitMask == ColliderType.Enemy.rawValue) {
                    sm.isInAttackRange = false
                }
            }
        }
    }
    
    func onDestinationReached(isReached:Bool) { }

    private func isColliderVisible(_ collider:SCNNode) -> Bool {
        guard let sm = self.stateMachine, let owner = sm.getOwner() as? EnemyEntity  else { return false }

        var direction = collider.getWorldPosition() - owner.getNode().position
        direction.y = 0.0 // CHECK THIS HACK
        let angleInDegrees = GameUtils.getAngleBetween(vectorA: owner.getNode().orientationVector(), vectorB: direction)
        print("ANGLE IN DEGREES is \(angleInDegrees)")
        if(angleInDegrees > owner.fov/2.0) {
            return false
        }
        return true
    }
}
