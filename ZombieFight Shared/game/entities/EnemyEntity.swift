//
//  EnemyEntity.swift
//  ZombieFight
//
//  Created by Vivek Nagar on 2/20/18.
//  Copyright © 2018 Vivek Nagar. All rights reserved.
//

import SceneKit

class EnemyEntity : Entity {
    private var name = ""
    private var node = SCNNode()
    private var animations = [String: CAAnimation]()
    private var currentAnimationState = EnemyAnimationState.Idle
    private var animationDict = [EnemyAnimationState: SCNNode]()
    private let scale = SCNVector3(0.007, 0.007, 0.007)
    private var direction = SCNVector3Zero
    private var velocity = SCNVector3Zero
    private var speed = Float(2.0)
    let contactTestBitMask = ColliderType.Player.rawValue
    let categoryBitMask = ColliderType.Enemy.rawValue
    
    init(name:String, baseName:String) {
        self.name = name
        self.node.name = name
        
        if let idleNode = GameUtils.loadNodeFromScene(filename: baseName + "Idle.dae") {
            idleNode.scale = scale
            node.addChildNode(idleNode)
            
            let physicsNode = SCNNode()
            physicsNode.name = name
            let geo = SCNCapsule(capRadius: 0.40, height: 1.0)
            let shape = SCNPhysicsShape(geometry: geo, options: nil)
            physicsNode.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.kinematic, shape: shape)
            physicsNode.physicsBody?.contactTestBitMask = contactTestBitMask
            physicsNode.physicsBody?.categoryBitMask = categoryBitMask
            physicsNode.position = SCNVector3(0.0, 0.5, 0.0)
            node.addChildNode(physicsNode)
        }
        
        //load Animations
        let idleAnimation = GameUtils.loadAnimation(sceneName: baseName + "Idle", withExtension: "dae", animationIdentifier: GameConstants.Enemy.idleAnimationIdentifier)
        animations[GameConstants.Enemy.idleAnimationKey] = idleAnimation
        let walkAnimation = GameUtils.loadAnimation(sceneName: baseName + "Walk", withExtension: "dae", animationIdentifier: GameConstants.Enemy.walkAnimationIdentifier)
        animations[GameConstants.Enemy.walkAnimationKey] = walkAnimation
        let alertedAnimation = GameUtils.loadAnimation(sceneName: baseName + "Alerted", withExtension: "dae", animationIdentifier: GameConstants.Enemy.alertedAnimationIdentifier)
        animations[GameConstants.Enemy.alertedAnimationKey] = alertedAnimation
        let hitAnimation = GameUtils.loadAnimation(sceneName: baseName + "Hit", withExtension: "dae", animationIdentifier: GameConstants.Enemy.hitAnimationIdentifier)
        animations[GameConstants.Enemy.hitAnimationKey] = hitAnimation
        let attackAnimation = GameUtils.loadAnimation(sceneName: baseName + "Attack", withExtension: "dae", animationIdentifier: GameConstants.Enemy.attackAnimationIdentifier)
        animations[GameConstants.Enemy.attackAnimationKey] = attackAnimation
        let dieAnimation = GameUtils.loadAnimation(sceneName: baseName + "Die", withExtension: "dae", animationIdentifier: GameConstants.Enemy.dieAnimationIdentifier)
        animations[GameConstants.Enemy.dieAnimationKey] = dieAnimation
        let runAnimation = GameUtils.loadAnimation(sceneName: baseName + "Run", withExtension: "dae", animationIdentifier: GameConstants.Enemy.runAnimationIdentifier)
        animations[GameConstants.Enemy.runAnimationKey] = runAnimation
        let screamAnimation = GameUtils.loadAnimation(sceneName: baseName + "Scream", withExtension: "dae", animationIdentifier: GameConstants.Enemy.screamAnimationIdentifier)
        animations[GameConstants.Enemy.screamAnimationKey] = screamAnimation
        let leftTurnAnimation = GameUtils.loadAnimation(sceneName: baseName + "LeftTurn", withExtension: "dae", animationIdentifier: GameConstants.Enemy.leftTurnAnimationIdentifier)
        animations[GameConstants.Enemy.leftTurnAnimationKey] = leftTurnAnimation
        let rightTurnAnimation = GameUtils.loadAnimation(sceneName: baseName + "RightTurn", withExtension: "dae", animationIdentifier: GameConstants.Enemy.rightTurnAnimationIdentifier)
        animations[GameConstants.Enemy.rightTurnAnimationKey] = rightTurnAnimation
        
        // Play the default animation
        node.removeAllAnimations()
        node.addAnimation(animations[GameConstants.Enemy.idleAnimationKey]!, forKey:GameConstants.Enemy.idleAnimationKey)
    }
    
    func getName() -> String {
        return self.name
    }
    
    func getNode() -> SCNNode {
        return self.node
    }
    
    func update(time:GameTime) {
    }
    
    func physicsUpdate(time: GameTime) {
    }
    
    func destroy() {
        node.removeFromParentNode()
    }
    
    func changeAnimationStateTo(newState:EnemyAnimationState) {
        if(newState == currentAnimationState) {
            return
        }
        
        switch(currentAnimationState) {
        case .Idle:
            node.removeAnimation(forKey:GameConstants.Enemy.idleAnimationKey)
            break
        case .Walk:
            node.removeAnimation(forKey:GameConstants.Enemy.walkAnimationKey)
            break
        case .Alert:
            node.removeAnimation(forKey:GameConstants.Enemy.alertedAnimationKey)
            break
        case .Attack:
            node.removeAnimation(forKey:GameConstants.Enemy.attackAnimationKey)
            break
        case .Hit:
            node.removeAnimation(forKey:GameConstants.Enemy.hitAnimationKey)
            break
        case .Die:
            node.removeAnimation(forKey:GameConstants.Enemy.dieAnimationKey)
            break
        case .Run:
            node.removeAnimation(forKey:GameConstants.Enemy.runAnimationKey)
            break
        case .Scream:
            node.removeAnimation(forKey:GameConstants.Enemy.screamAnimationKey)
            break
        case .LeftTurn:
            node.removeAnimation(forKey:GameConstants.Enemy.leftTurnAnimationKey)
            break
        case .RightTurn:
            node.removeAnimation(forKey:GameConstants.Enemy.rightTurnAnimationKey)
            break
        }
        switch(newState) {
        case .Idle:
            node.addAnimation(animations[GameConstants.Enemy.idleAnimationKey]!, forKey:GameConstants.Enemy.idleAnimationKey)
            break
        case .Walk:
            node.addAnimation(animations[GameConstants.Enemy.walkAnimationKey]!, forKey:GameConstants.Enemy.walkAnimationKey)
            break
        case .Alert:
            node.addAnimation(animations[GameConstants.Enemy.alertedAnimationKey]!, forKey:GameConstants.Enemy.alertedAnimationKey)
            break
        case .Attack:
            node.addAnimation(animations[GameConstants.Enemy.attackAnimationKey]!, forKey:GameConstants.Enemy.attackAnimationKey)
            break
        case .Hit:
            node.addAnimation(animations[GameConstants.Enemy.hitAnimationKey]!, forKey:GameConstants.Enemy.hitAnimationKey)
            break
        case .Run:
            node.addAnimation(animations[GameConstants.Enemy.runAnimationKey]!, forKey:GameConstants.Enemy.runAnimationKey)
            break
        case .Scream:
            node.addAnimation(animations[GameConstants.Enemy.screamAnimationKey]!, forKey:GameConstants.Enemy.screamAnimationKey)
            break
        case .Die:
            let animationObject = animations[GameConstants.Enemy.dieAnimationKey]!
            animationObject.repeatCount = 1
            node.addAnimation(animationObject, forKey:GameConstants.Enemy.dieAnimationKey)
            break
        case .LeftTurn:
            node.addAnimation(animations[GameConstants.Enemy.leftTurnAnimationKey]!, forKey:GameConstants.Enemy.leftTurnAnimationKey)
            break
        case .RightTurn:
            node.addAnimation(animations[GameConstants.Enemy.rightTurnAnimationKey]!, forKey:GameConstants.Enemy.rightTurnAnimationKey)
            break
        }
        currentAnimationState = newState
    }
}
