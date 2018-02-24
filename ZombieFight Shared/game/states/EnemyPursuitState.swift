//
//  EnemyPursuitState.swift
//  ZombieFight
//
//  Created by Vivek Nagar on 2/23/18.
//  Copyright © 2018 Vivek Nagar. All rights reserved.
//

import SceneKit

class EnemyPursuitState : EnemyState {
    private var timer = 0.0
    private var repathTimer = 0.0
    private var repathDuration = 0.05
    private let maxPursuitDuration = 30.0
    
    override init() {
        super.init()
    }
    
    override func onEnterState() {
        super.onEnterState()
        print("Entering Enemy Pursuit State")
        timer = 0.0
        repathTimer = 0.0
        
        if let sm = self.stateMachine, let owner = sm.getOwner() as? EnemyEntity  {
            owner.changeAnimationStateTo(newState: .Run)
            owner.setDestination(targetPosition: sm.target.position)
        }
    }
    override func onExitState() {
        print("Exiting pursuit state")
    }
    
    override func getStateType() -> EnemyStateType { return EnemyStateType.Pursuit }
    
    override func onUpdate(time:GameTime) -> EnemyStateType {
        guard let sm = self.stateMachine, let owner = sm.getOwner() as? EnemyEntity  else { return .None }
        timer = timer + time.deltaTime
        repathTimer = repathTimer + time.deltaTime
        
        if(timer > maxPursuitDuration) {
            return .Patrol
        }
        if(sm.isInAttackRange) {
            return .Attack
        }
        
        //repath more frequently as we get closer to target
        if(repathTimer > 0.5) {
            //print("REpath to \(sm.visualThreat.position)")
            let newposition = sm.target.collider!.getWorldPosition()
            let distance = (owner.getNode().position - newposition).length()
            sm.setTarget(t:sm.target.type, c:sm.target.collider, p:newposition, d:distance)
            owner.setDestination(targetPosition: sm.target.position)
            repathTimer = 0
        }
        
        if(sm.target.type == .Visual_Player) {
            return .Pursuit
        }
        return .Pursuit
    }
}
