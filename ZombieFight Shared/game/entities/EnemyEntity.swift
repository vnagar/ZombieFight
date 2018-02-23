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
    private var physicsNode = SCNNode()
    private var sensorNode = SCNNode()
    private var currentAnimationState = EnemyAnimationState.Idle
    private var animationDict = [EnemyAnimationState: String]()
    private let scale = SCNVector3(0.007, 0.007, 0.007)
    private var direction = SCNVector3Zero
    private var velocity = SCNVector3Zero
    let contactTestBitMask = ColliderType.Player.rawValue
    let categoryBitMask = ColliderType.Enemy.rawValue
    let enemySensorBitMask = ColliderType.EnemySensor.rawValue
    let sensorContactTestBitMask = ColliderType.Player.rawValue
    
    private var _fov = Float(60.0)
    private var _sight = Float(1.0) // between 0 and 1
    private var _hearing = Float(1.0) // between 0 and 1
    private var _aggression = Float(0.8) // between 0 and 1
    private var _health = 100 // between 0 and 100
    private var _intelligence = Float(1.0) // between 0 and 1
    private var _satisfaction = Float(1.0) // between 0 and 1
    private var _inMeleeRange:Bool = false
    private var _speed = Float(0.1)
    private let _maxSpeed = 0.3
    private let _brakingRate = Float(0.75)
    private let _mass = Float(1.0)

    private var targetPath = [SCNVector3Zero]
    
    var fov:Float {get {return _fov}}
    var sight:Float {get {return _sight}}
    var hearing:Float {get {return _hearing}}
    var aggression:Float {get {return _aggression} set { _aggression = newValue } }
    var health:Int {get {return _health} set { _health = newValue} }
    var intelligence:Float {get {return _intelligence}}
    var satisfaction:Float {get {return _satisfaction} set { _satisfaction = newValue } }
    var inMeleeRange : Bool {get {return _inMeleeRange} set {_inMeleeRange = newValue}}
    var speed : Float {get {return _speed} set {_speed = newValue}}
    
    private var directionAngle: SCNFloat = 0.0 {
        didSet {
            if directionAngle != oldValue {
                node.runAction(SCNAction.rotateTo(x: 0.0, y: CGFloat(directionAngle), z: 0.0, duration: 0.1, usesShortestUnitArc: true))
            }
        }
    }
    
    init(name:String, baseName:String) {
        self.name = name
        self.node.name = name
        
        if let idleNode = GameUtils.loadNodeFromScene(filename: baseName + "Idle.dae") {
            idleNode.scale = scale
            node.addChildNode(idleNode)
            
            physicsNode.name = name
            let geo = SCNCapsule(capRadius: 0.40, height: 1.0)
            let shape = SCNPhysicsShape(geometry: geo, options: nil)
            physicsNode.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.kinematic, shape: shape)
            physicsNode.physicsBody?.contactTestBitMask = contactTestBitMask
            physicsNode.physicsBody?.categoryBitMask = categoryBitMask
            physicsNode.position = SCNVector3(0.0, 0.5, 0.0)
            node.addChildNode(physicsNode)
            
            sensorNode.name = self.name + "Sensor"
            sensorNode.position = SCNVector3Make(0.0, 0.0, 0.0)
            let shape1 = SCNPhysicsShape(geometry: SCNSphere(radius:5.0), options: nil)
            sensorNode.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.kinematic, shape: shape1)
            sensorNode.physicsBody?.contactTestBitMask = sensorContactTestBitMask
            sensorNode.physicsBody?.categoryBitMask = enemySensorBitMask
            node.addChildNode(sensorNode)
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
    
    func getPhysicsNode() -> SCNNode {
        return self.physicsNode
    }
    
    func getSensorNode() -> SCNNode {
        return self.sensorNode
    }
    
    func update(time:GameTime) {
        if(currentAnimationState == .Idle || currentAnimationState == .Attack) {
            return
        }
        //let force = seek(target:currentDestination)
        //let force = arrive(target:targetPosition, decelerationFactor: 0.75)
        let force = followPath(path:targetPath)
        if (force == SCNVector3Zero) {
            velocity = velocity * _brakingRate
        }
        //calculate the acceleration
        let accel = force / SCNFloat(_mass)
        //update the velocity
        velocity = SCNVector3(velocity.x + accel.x, velocity.y, velocity.z + accel.z)
        //make sure enemy does not exceed maximum velocity
        velocity = velocity.truncate(max: Float(_maxSpeed))
        
        if(velocity.lengthSquared() < 0.0001) {
            print("Reached destination")
        } else {
            node.position = node.position + velocity * Float(time.deltaTime)
            let heading = velocity.normalized()
            directionAngle = SCNFloat(atan2(heading.x, heading.z))
        }
    }
    
    func physicsUpdate(time: GameTime) {
    }
    
    func destroy() {
        node.removeFromParentNode()
    }
    
    private var currentIndex = 0

    func setDestination(targetPosition:SCNVector3) {
        currentIndex = 0
        print("Setting destination to \(targetPosition)")
        if let navmesh = EntityManager.sharedInstance.getNavigationMesh() {
            self.targetPath = navmesh.findPathBetweenPoints(fromPoint: self.node.position, toPoint: targetPosition)
        } else {
            self.targetPath = [targetPosition]
        }
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
    
    private func seek(target:SCNVector3) -> SCNVector3 {
        let toTarget = target - node.position
        let distance = toTarget.length()
        if(distance > 0) {
            let desiredVelocity = toTarget * Float(_maxSpeed) / SCNFloat(distance)
            
            return (desiredVelocity - velocity)
        }
        return SCNVector3Zero
    }
    
    private func arrive(target:SCNVector3, decelerationFactor:Float) -> SCNVector3 {
        let toTarget = target - node.position
        let distance = toTarget.length()
        
        if(distance > 0.1) {
            var speed = distance/decelerationFactor
            
            //make sure velocity does not exceed max
            if(speed > Float(_maxSpeed)) {
                speed = Float(_maxSpeed)
            }
            let desiredVelocity = toTarget * speed / SCNFloat(distance)
            return (desiredVelocity - velocity)
        }
        return SCNVector3Zero
    }
    
    func followPath(path:[SCNVector3]) -> SCNVector3 {
        if(currentIndex == path.count) {
            return SCNVector3Zero
        }
        let currentWaypoint = path[currentIndex]
            
        if((self.node.position - currentWaypoint).length() < 0.1) {
            print("Reached next waypoint, updating index to \(currentIndex + 1)")
            currentIndex = currentIndex + 1
            if(currentIndex == path.count) {
                // reach last
                return arrive(target: currentWaypoint, decelerationFactor:1.0)
            }
        } else {
            if(currentIndex <= path.count-1) {
                return seek(target: currentWaypoint)
            } else {
                return arrive(target: currentWaypoint, decelerationFactor:1.0)
            }
        }
        return SCNVector3Zero
    }

}
