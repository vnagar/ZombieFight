//
//  PlayerEntity.swift
//  ZombieFight
//
//  Created by Vivek Nagar on 2/20/18.
//  Copyright © 2018 Vivek Nagar. All rights reserved.
//

import SceneKit

class PlayerEntity : Entity {
    private var name = ""
    private var node = SCNNode()
    private let cameraNode = SCNNode()
    private var animations = [String: CAAnimation]()
    private var currentAnimationState = PlayerAnimationState.Idle
    private var animationDict = [PlayerAnimationState: SCNNode]()
    private let scale = SCNVector3(0.0006, 0.0006, 0.0006)
    private let baseName = "Art.scnassets/characters/player/"
    
    init(name:String) {
        self.name = name
        self.node.name = name
        
        if let idleNode = GameUtils.loadNodeFromScene(filename: baseName + "Idle.dae") {
            idleNode.scale = scale
            
            node.addChildNode(idleNode)
        }
        //load Animations
        let idleAnimation = GameUtils.loadAnimation(sceneName: baseName + "Idle", withExtension: "dae", animationIdentifier: GameConstants.Player.idleAnimationIdentifier)
        animations[GameConstants.Player.idleAnimationKey] = idleAnimation
        let walkAnimation = GameUtils.loadAnimation(sceneName: baseName + "Walk", withExtension: "dae", animationIdentifier: GameConstants.Player.walkAnimationIdentifier)
        animations[GameConstants.Player.walkAnimationKey] = walkAnimation
        let kickAnimation = GameUtils.loadAnimation(sceneName: baseName + "Kick", withExtension: "dae", animationIdentifier: GameConstants.Player.kickAnimationIdentifier)
        animations[GameConstants.Player.kickAnimationKey] = kickAnimation
        let punchAnimation = GameUtils.loadAnimation(sceneName: baseName + "Punch", withExtension: "dae", animationIdentifier: GameConstants.Player.punchAnimationIdentifier)
        animations[GameConstants.Player.punchAnimationKey] = punchAnimation
        let shootAnimation = GameUtils.loadAnimation(sceneName: baseName + "Shoot", withExtension: "dae", animationIdentifier: GameConstants.Player.shootAnimationIdentifier)
        animations[GameConstants.Player.shootAnimationKey] = shootAnimation
        let dieAnimation = GameUtils.loadAnimation(sceneName: baseName + "Die", withExtension: "dae", animationIdentifier: GameConstants.Player.dieAnimationIdentifier)
        animations[GameConstants.Player.dieAnimationKey] = dieAnimation
        let runAnimation = GameUtils.loadAnimation(sceneName: baseName + "Run", withExtension: "dae", animationIdentifier: GameConstants.Player.runAnimationIdentifier)
        animations[GameConstants.Player.runAnimationKey] = runAnimation
        let jumpAnimation = GameUtils.loadAnimation(sceneName: baseName + "Jump", withExtension: "dae", animationIdentifier: GameConstants.Player.jumpAnimationIdentifier)
        animations[GameConstants.Player.jumpAnimationKey] = jumpAnimation
        
        // Play the default animation
        node.removeAllAnimations()
        node.addAnimation(animations[GameConstants.Player.idleAnimationKey]!, forKey:GameConstants.Player.idleAnimationKey)
        
        let (min, max) = self.node.boundingBox
        let box = SCNBox(width: CGFloat(max.x-min.x), height: CGFloat(max.y-min.y), length: CGFloat(max.z-min.z), chamferRadius: 0.0)
        //print("BOX is \(box)")
        // Add camera to player
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: SCNFloat(box.height+1.0), z: -2.0)
        cameraNode.eulerAngles = SCNVector3(-Double.pi/8, Double.pi, 0.0)
        node.addChildNode(cameraNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getName() -> String {
        return self.name
    }
    
    func getNode() -> SCNNode {
        return self.node
    }
    
    func getCameraNode() -> SCNNode {
        return self.cameraNode
    }
    
    func update(time:GameTime) {
    }
    
    func physicsUpdate(time: GameTime) {
    }
    
    func destroy() {
        node.removeFromParentNode()
    }
    
    func changeAnimationStateTo(newState:PlayerAnimationState) {
        if(newState == currentAnimationState) {
            return
        }
        
        switch(currentAnimationState) {
        case .Idle:
            node.removeAnimation(forKey:GameConstants.Player.idleAnimationKey)
            break
        case .Walk:
            node.removeAnimation(forKey:GameConstants.Player.walkAnimationKey)
            break
        case .Punch:
            node.removeAnimation(forKey:GameConstants.Player.punchAnimationKey)
            break
        case .Kick:
            node.removeAnimation(forKey:GameConstants.Player.kickAnimationKey)
            break
        case .Shoot:
            node.removeAnimation(forKey:GameConstants.Player.shootAnimationKey)
            break
        case .Die:
            node.removeAnimation(forKey:GameConstants.Player.dieAnimationKey)
            break
        case .Run:
            node.removeAnimation(forKey:GameConstants.Player.runAnimationKey)
            break
        case .Jump:
            node.removeAnimation(forKey:GameConstants.Player.jumpAnimationKey)
            break
        }
        switch(newState) {
        case .Idle:
            node.addAnimation(animations[GameConstants.Player.idleAnimationKey]!, forKey:GameConstants.Player.idleAnimationKey)
            break
        case .Walk:
            node.addAnimation(animations[GameConstants.Player.walkAnimationKey]!, forKey:GameConstants.Player.walkAnimationKey)
            break
        case .Punch:
            node.addAnimation(animations[GameConstants.Player.punchAnimationKey]!, forKey:GameConstants.Player.punchAnimationKey)
            break
        case .Kick:
            node.addAnimation(animations[GameConstants.Player.kickAnimationKey]!, forKey:GameConstants.Player.kickAnimationKey)
            break
        case .Shoot:
            node.addAnimation(animations[GameConstants.Player.shootAnimationKey]!, forKey:GameConstants.Player.shootAnimationKey)
            break
        case .Run:
            node.addAnimation(animations[GameConstants.Player.runAnimationKey]!, forKey:GameConstants.Player.runAnimationKey)
            break
        case .Jump:
            node.addAnimation(animations[GameConstants.Player.jumpAnimationKey]!, forKey:GameConstants.Player.jumpAnimationKey)
            break
        case .Die:
            let animationObject = animations[GameConstants.Player.dieAnimationKey]!
            animationObject.repeatCount = 1
            node.addAnimation(animationObject, forKey:GameConstants.Player.dieAnimationKey)
            break
        }
        currentAnimationState = newState
    }
}
