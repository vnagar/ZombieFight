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
    private var animationDict = [PlayerAnimationState: String]()
    private var currentAnimationState = PlayerAnimationState.Idle
    private let scale = SCNVector3(0.0006, 0.0006, 0.0006)
    private var direction = SCNVector3Zero
    private var velocity = SCNVector3Zero
    private var speed = Float(2.0)
    private let baseName = "Art.scnassets/characters/player/"
    let contactTestBitMask = ColliderType.Enemy.rawValue | ColliderType.Wall.rawValue
    let categoryBitMask = ColliderType.Player.rawValue
    
    // Sound effects
    private var audioSetUp = false
    private var aahSound: SCNAudioSource!
    private var ouchSound: SCNAudioSource!
    private var hitSound: SCNAudioSource!
    private var hitEnemySound: SCNAudioSource!
    private var explodeEnemySound: SCNAudioSource!
    private var catchFireSound: SCNAudioSource!
    private var jumpSound: SCNAudioSource!
    private var attackSound: SCNAudioSource!
    static private let stepsCount = 10
    private var steps = [SCNAudioSource](repeating: SCNAudioSource(), count: PlayerEntity.stepsCount )
    
    init(name:String) {
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
        node.removeAllAnimations()

        let idleAnimation = GameUtils.loadAnimation(fromSceneNamed: baseName + "Idle.dae")
        node.addAnimationPlayer(idleAnimation, forKey:GameConstants.Player.idleAnimationKey)
        animationDict[.Idle] = GameConstants.Player.idleAnimationKey
        
        let walkAnimation = GameUtils.loadAnimation(fromSceneNamed: baseName + "Walk.dae")
        node.addAnimationPlayer(walkAnimation, forKey:GameConstants.Player.walkAnimationKey)
        animationDict[.Walk] = GameConstants.Player.walkAnimationKey
        walkAnimation.stop()
    
        let kickAnimation = GameUtils.loadAnimation(fromSceneNamed: baseName + "Kick.dae")
        node.addAnimationPlayer(kickAnimation, forKey:GameConstants.Player.kickAnimationKey)
        animationDict[.Kick] = GameConstants.Player.kickAnimationKey
        kickAnimation.stop()
        
        let punchAnimation = GameUtils.loadAnimation(fromSceneNamed: baseName + "Punch.dae")
        node.addAnimationPlayer(punchAnimation, forKey:GameConstants.Player.punchAnimationKey)
        animationDict[.Punch] = GameConstants.Player.punchAnimationKey
        punchAnimation.stop()
        
        let shootAnimation = GameUtils.loadAnimation(fromSceneNamed: baseName + "Shoot.dae")
        node.addAnimationPlayer(shootAnimation, forKey:GameConstants.Player.shootAnimationKey)
        animationDict[.Shoot] = GameConstants.Player.shootAnimationKey
        shootAnimation.stop()
        
        let dieAnimation = GameUtils.loadAnimation(fromSceneNamed: baseName + "Die.dae")
        dieAnimation.animation.repeatCount = 1
        dieAnimation.animation.animationDidStop = { _, _ , _ in
            print("Player die animation DID STOP")
        }
        node.addAnimationPlayer(dieAnimation, forKey:GameConstants.Player.dieAnimationKey)
        animationDict[.Die] = GameConstants.Player.dieAnimationKey
        dieAnimation.stop()
        
        let runAnimation = GameUtils.loadAnimation(fromSceneNamed: baseName + "Run.dae")
        node.addAnimationPlayer(runAnimation, forKey:GameConstants.Player.runAnimationKey)
        animationDict[.Run] = GameConstants.Player.runAnimationKey
        runAnimation.stop()
        
        let jumpAnimation = GameUtils.loadAnimation(fromSceneNamed: baseName + "Jump.dae")
        node.addAnimationPlayer(jumpAnimation, forKey:GameConstants.Player.jumpAnimationKey)
        animationDict[.Jump] = GameConstants.Player.jumpAnimationKey
        jumpAnimation.stop()
        
        let leftTurnAnimation = GameUtils.loadAnimation(fromSceneNamed: baseName + "LeftTurn.dae")
        node.addAnimationPlayer(leftTurnAnimation, forKey:GameConstants.Player.leftTurnAnimationKey)
        animationDict[.LeftTurn] = GameConstants.Player.leftTurnAnimationKey
        print("Duration for leftTurn is \(leftTurnAnimation.animation.duration)")
        leftTurnAnimation.stop()
        
        let rightTurnAnimation = GameUtils.loadAnimation(fromSceneNamed: baseName + "RightTurn.dae")
        node.addAnimationPlayer(rightTurnAnimation, forKey:GameConstants.Player.rightTurnAnimationKey)
        animationDict[.RightTurn] = GameConstants.Player.rightTurnAnimationKey
        print("Duration for rightTurn is \(rightTurnAnimation.animation.duration)")
        rightTurnAnimation.stop()
        
        // Play the default animation
        idleAnimation.play()
        
        let (min, max) = self.node.boundingBox
        let box = SCNBox(width: CGFloat(max.x-min.x), height: CGFloat(max.y-min.y), length: CGFloat(max.z-min.z), chamferRadius: 0.0)
        //print("BOX is \(box)")
        // Add camera to player
        cameraNode.camera = SCNCamera()
        cameraNode.camera?.wantsDepthOfField = true
        cameraNode.camera?.wantsHDR = true
        cameraNode.camera?.focusDistance = 0.8 // meters
        cameraNode.camera?.fStop = 5.6
        cameraNode.position = SCNVector3(x: 0, y: SCNFloat(box.height+0.5), z: -1.0)
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
        if(audioSetUp == false) {
            self.loadSounds()
            audioSetUp = true
        }
        self.velocity = self.direction * speed
        node.position = node.position - velocity * Float(time.deltaTime)
    }
    
    func setDirection(_ direction:SCNVector3) {
        self.direction = direction.negate()
    }
    
    func getVelocity() -> SCNVector3 {
        return self.velocity
    }
    
    func changeRotationBy(angleInRadians:Float) {
        var rotation = self.node.rotation
        rotation.w = rotation.w + SCNFloat(angleInRadians)
        let action = SCNAction.rotate(toAxisAngle: SCNVector4(0, 1, 0, rotation.w), duration: 0.25)
        let curAnim = currentAnimationState
        if(angleInRadians < 0) {
            self.changeAnimationStateTo(newState: .RightTurn)
        } else {
            self.changeAnimationStateTo(newState: .LeftTurn)
        }
        self.node.runAction(action, completionHandler: { () in
            self.changeAnimationStateTo(newState: curAnim)
        })
    }
    
    func physicsUpdate(time: GameTime) {
    }
    
    func destroy() {
        node.removeAllAnimations()
        node.removeFromParentNode()
    }
    
    func changeAnimationStateTo(newState:PlayerAnimationState) {
        if(newState == currentAnimationState) {
            return
        }
        
        if let animationKey = animationDict[currentAnimationState] {
            let anim = node.animationPlayer(forKey:animationKey)!
            anim.animation.animationEvents = []
            anim.stop()
        }
        if let newAnimationKey = animationDict[newState] {
            let anim = node.animationPlayer(forKey:newAnimationKey)!
            if(newState == .Walk) {
                anim.animation.animationEvents = [
                    SCNAnimationEvent(keyTime: 0.1, block: { _, _, _ in self.playFootStep() }),
                    SCNAnimationEvent(keyTime: 0.6, block: { _, _, _ in self.playFootStep() })
                ]
            }
            anim.play()
        }
        
        currentAnimationState = newState
    }
    
    private func playFootStep() {
        let randSnd: Int = Int(Float(arc4random()) / Float(RAND_MAX) * Float(PlayerEntity.stepsCount))
        let stepSoundIndex: Int = min(PlayerEntity.stepsCount - 1, randSnd)
        self.node.runAction(SCNAction.playAudio( steps[stepSoundIndex], waitForCompletion: false))
    }
    
    private func loadSounds() {
        aahSound = SCNAudioSource( named: "Art.scnassets/sounds/aah_extinction.mp3")!
        aahSound.volume = 1.0
        aahSound.isPositional = false
        aahSound.load()
        
        catchFireSound = SCNAudioSource(named: "Art.scnassets/sounds/catch_fire.mp3")!
        catchFireSound.volume = 5.0
        catchFireSound.isPositional = false
        catchFireSound.load()
        
        ouchSound = SCNAudioSource(named: "Art.scnassets/sounds/ouch_firehit.mp3")!
        ouchSound.volume = 2.0
        ouchSound.isPositional = false
        ouchSound.load()
        
        hitSound = SCNAudioSource(named: "Art.scnassets/sounds/hit.mp3")!
        hitSound.volume = 2.0
        hitSound.isPositional = false
        hitSound.load()
        
        hitEnemySound = SCNAudioSource(named: "Art.scnassets/sounds/Explosion1.m4a")!
        hitEnemySound.volume = 2.0
        hitEnemySound.isPositional = false
        hitEnemySound.load()
        
        explodeEnemySound = SCNAudioSource(named: "Art.scnassets/sounds/Explosion2.m4a")!
        explodeEnemySound.volume = 2.0
        explodeEnemySound.isPositional = false
        explodeEnemySound.load()
        
        jumpSound = SCNAudioSource(named: "Art.scnassets/sounds/jump.m4a")!
        jumpSound.volume = 0.2
        jumpSound.isPositional = false
        jumpSound.load()
        
        attackSound = SCNAudioSource(named: "Art.scnassets/sounds/attack.mp3")!
        attackSound.volume = 1.0
        attackSound.isPositional = false
        attackSound.load()
        
        for i in 0..<PlayerEntity.stepsCount {
            steps[i] = SCNAudioSource(named: "Art.scnassets/sounds/Step_rock_0\(UInt32(i)).mp3")!
            steps[i].volume = 0.5
            steps[i].isPositional = false
            steps[i].load()
        }
    }
}
