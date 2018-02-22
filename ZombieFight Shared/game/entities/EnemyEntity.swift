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
    private var currentAnimationState = EnemyAnimationState.Idle
    private var animationDict = [EnemyAnimationState: String]()
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
        
        node.removeAllAnimations()
        
        //load Animations
        let idleAnimation = GameUtils.loadAnimation(fromSceneNamed: baseName + "Idle.dae")
        node.addAnimationPlayer(idleAnimation, forKey:GameConstants.Enemy.idleAnimationKey)
        animationDict[.Idle] = GameConstants.Enemy.idleAnimationKey
        idleAnimation.stop()
        
        let walkAnimation = GameUtils.loadAnimation(fromSceneNamed: baseName + "Walk.dae")
        node.addAnimationPlayer(walkAnimation, forKey:GameConstants.Enemy.walkAnimationKey)
        animationDict[.Walk] = GameConstants.Enemy.walkAnimationKey
        walkAnimation.stop()

        let alertedAnimation = GameUtils.loadAnimation(fromSceneNamed: baseName + "Alerted.dae")
        node.addAnimationPlayer(alertedAnimation, forKey:GameConstants.Enemy.alertedAnimationKey)
        animationDict[.Alert] = GameConstants.Enemy.alertedAnimationKey
        alertedAnimation.stop()

        let hitAnimation = GameUtils.loadAnimation(fromSceneNamed: baseName + "Hit.dae")
        node.addAnimationPlayer(hitAnimation, forKey:GameConstants.Enemy.hitAnimationKey)
        animationDict[.Hit] = GameConstants.Enemy.hitAnimationKey
        hitAnimation.stop()

        let attackAnimation = GameUtils.loadAnimation(fromSceneNamed: baseName + "Attack.dae")
        node.addAnimationPlayer(attackAnimation, forKey:GameConstants.Enemy.attackAnimationKey)
        animationDict[.Attack] = GameConstants.Enemy.attackAnimationKey
        attackAnimation.stop()

        let dieAnimation = GameUtils.loadAnimation(fromSceneNamed: baseName + "Die.dae")
        node.addAnimationPlayer(dieAnimation, forKey:GameConstants.Enemy.dieAnimationKey)
        animationDict[.Die] = GameConstants.Enemy.dieAnimationKey
        dieAnimation.animation.repeatCount = 1
        dieAnimation.animation.animationDidStop = { _, _ , _ in
            print("Enemy die ANIMATION DID STOP")
        }
        dieAnimation.stop()

        let runAnimation = GameUtils.loadAnimation(fromSceneNamed: baseName + "Run.dae")
        node.addAnimationPlayer(runAnimation, forKey:GameConstants.Enemy.runAnimationKey)
        animationDict[.Run] = GameConstants.Enemy.runAnimationKey
        runAnimation.stop()

        let screamAnimation = GameUtils.loadAnimation(fromSceneNamed: baseName + "Scream.dae")
        node.addAnimationPlayer(screamAnimation, forKey:GameConstants.Enemy.screamAnimationKey)
        animationDict[.Scream] = GameConstants.Enemy.screamAnimationKey
        screamAnimation.stop()

        let leftTurnAnimation = GameUtils.loadAnimation(fromSceneNamed: baseName + "LeftTurn.dae")
        node.addAnimationPlayer(leftTurnAnimation, forKey:GameConstants.Enemy.leftTurnAnimationKey)
        animationDict[.LeftTurn] = GameConstants.Enemy.leftTurnAnimationKey
        leftTurnAnimation.stop()

        let rightTurnAnimation = GameUtils.loadAnimation(fromSceneNamed: baseName + "RightTurn.dae")
        node.addAnimationPlayer(rightTurnAnimation, forKey:GameConstants.Enemy.rightTurnAnimationKey)
        animationDict[.RightTurn] = GameConstants.Enemy.leftTurnAnimationKey
        rightTurnAnimation.stop()

        // Play the default animation
        idleAnimation.play()
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
        
        if let animationKey = animationDict[currentAnimationState] {
            node.animationPlayer(forKey:animationKey)!.stop()
        }
        if let newAnimationKey = animationDict[newState] {
            node.animationPlayer(forKey:newAnimationKey)!.play()
        }
        
        currentAnimationState = newState
    }
}
