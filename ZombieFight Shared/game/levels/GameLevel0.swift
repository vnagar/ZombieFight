//
//  GameLevel0.swift
//  Adventure
//
//  Created by Vivek Nagar on 1/18/18.
//  Copyright © 2018 Vivek Nagar. All rights reserved.
//

import SceneKit
import SpriteKit
import simd

class GameLevel0 : GameLevel {
    private var player:PlayerEntity?
    private var toggleCamera = false
    private var mainCameraNode = SCNNode()
    private var currentCameraNode = SCNNode()
    private var playerCameraNode = SCNNode()
    private let playerSpawnPoint = SCNVector3(-6.0, 0.0, 5.0)
    private let enemySpawnPoint = SCNVector3(-7.0, 0.0, -3.0)
    private var audioSetUp = false

    let gameTime = GameTime()
    
    override init() {
        super.init()
    }
    
    override func createLevel(sceneView:SCNView) -> SCNScene {
        self.sceneView = sceneView
        //self.scene = SCNScene(named: "Art.scnassets/ship.scn")!
        self.scene = SCNScene(named: "Art.scnassets/models/bunker.dae")!
        if let navmeshNode = scene.rootNode.childNode(withName: "Navmesh", recursively: true) {
            let navmesh = NavigationMesh(scene: scene, node: navmeshNode)
            EntityManager.sharedInstance.setNavigationMesh(navmesh)
            navmeshNode.removeFromParentNode()
        } else {
            print("Cannot find navigation mesh in scene")
        }
        
        return scene
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if(audioSetUp == false) {
            self.setupAudio()
            audioSetUp = true
        }
        if(toggleCamera) {
            if (currentCameraNode == mainCameraNode) {
                currentCameraNode = playerCameraNode
            } else {
                currentCameraNode = mainCameraNode
            }
            renderer.pointOfView = currentCameraNode
            toggleCamera = false
        }
        gameTime.update(time: time)
        EntityManager.sharedInstance.update(time: gameTime)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didSimulatePhysicsAtTime time: TimeInterval) {
        EntityManager.sharedInstance.physicsUpdate(time: gameTime)
    }
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        print("Collision between \(contact.nodeA) and \(contact.nodeB)")
        contact.match(ColliderType.Player.rawValue) { (matching, other) in
            if(other.name == "Wall" || other.name == "Box1" || other.name == "Box2") {
                player!.getNode().position -= player!.getNode().orientationVector() * 0.1
            }
        }
        contact.match(ColliderType.Enemy.rawValue) { (matching, other) in
            print("Contact happened with:\(matching.name ?? "noname") and \(other.name ?? "noname")")
            let sm = EntityManager.sharedInstance.getAIStateMachine(collider: matching)
            sm?.onTriggerEvent(eventType: AITriggerEventType.Enter, collider: other, matchingCollider:matching)
        }
        contact.match(ColliderType.EnemySensor.rawValue) { (matching, other) in
            print("Contact happened with:\(matching.name ?? "noname") and \(other.name ?? "noname")")
            let sm = EntityManager.sharedInstance.getAIStateMachine(collider: matching)
            sm?.onTriggerEvent(eventType: AITriggerEventType.Enter, collider: other, matchingCollider:matching)
        }
    }
    
    func physicsWorld(_ world: SCNPhysicsWorld, didUpdate contact: SCNPhysicsContact) {
        contact.match(ColliderType.Enemy.rawValue) { (matching, other) in
            print("Contact update with:\(matching.name ?? "noname") and \(other.name ?? "noname")")
            let sm = EntityManager.sharedInstance.getAIStateMachine(collider: matching)
            sm?.onTriggerEvent(eventType: AITriggerEventType.Stay, collider: other, matchingCollider:matching)
        }
        contact.match(ColliderType.EnemySensor.rawValue) { (matching, other) in
            print("Contact update with:\(matching.name ?? "noname") and \(other.name ?? "noname")")
            let sm = EntityManager.sharedInstance.getAIStateMachine(collider: matching)
            sm?.onTriggerEvent(eventType: AITriggerEventType.Stay, collider: other, matchingCollider:matching)
        }
    }
    
    func physicsWorld(_ world: SCNPhysicsWorld, didEnd contact: SCNPhysicsContact) {
        contact.match(ColliderType.Enemy.rawValue) { (matching, other) in
            print("Contact exit with:\(matching.name ?? "noname") and \(other.name ?? "noname")")
            let sm = EntityManager.sharedInstance.getAIStateMachine(collider: matching)
            sm?.onTriggerEvent(eventType: AITriggerEventType.Exit, collider: other, matchingCollider:matching)
        }
        contact.match(ColliderType.EnemySensor.rawValue) { (matching, other) in
            print("Contact exit with:\(matching.name ?? "noname") and \(other.name ?? "noname")")
            let sm = EntityManager.sharedInstance.getAIStateMachine(collider: matching)
            sm?.onTriggerEvent(eventType: AITriggerEventType.Exit, collider: other, matchingCollider:matching)
        }
    }
    
    override func startLevel() {
        super.startLevel()
        self.addHUD()
        self.setupPhysicsBodies()
        
        // create and add a camera to the scene
        mainCameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(mainCameraNode)
        
        // place the camera
        mainCameraNode.position = SCNVector3(x: 0, y: 10, z: 15)
        mainCameraNode.rotation = SCNVector4(1.0, 0.0, 0.0, -Double.pi/4)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = SCNColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
        
        self.player = EntityManager.sharedInstance.createPlayer()
        guard let p = self.player else { fatalError("Cannot create player") }
        scene.rootNode.addChildNode(p.getNode())
        playerCameraNode = p.getCameraNode()
        currentCameraNode = playerCameraNode

        p.getNode().position = playerSpawnPoint
        p.getNode().eulerAngles = SCNVector3(0.0, Double.pi, 0.0)
        
        let enemies = EntityManager.sharedInstance.createEnemies()
        for enemy in enemies {
            scene.rootNode.addChildNode(enemy.getNode())
            enemy.getNode().position = enemySpawnPoint
        }
        
        sceneView.pointOfView = currentCameraNode

    }
    
    override func levelFailed() {
        EntityManager.sharedInstance.clearEntities()
        self.cleanupScene()
        GameScenesManager.sharedInstance.setGameState(gameState: .LevelFailed, levelIndex:0)
    }
    
    override func levelCompleted() {
        EntityManager.sharedInstance.clearEntities()
        self.cleanupScene()
        GameScenesManager.sharedInstance.setGameState(gameState: .LevelComplete, levelIndex:0)
    }
    
    private func setupPhysicsBodies() {
        guard let wall = scene.rootNode.childNode(withName: "Wall", recursively: true) else { return }
        self.addPhysicsShape(node: wall, category:ColliderType.Wall.rawValue)
        
        guard let block1 = scene.rootNode.childNode(withName: "Box1", recursively: true) else { return }
        self.addPhysicsShape(node: block1, category:ColliderType.Block.rawValue)
        
        guard let block2 = scene.rootNode.childNode(withName: "Box2", recursively: true) else { return }
        self.addPhysicsShape(node: block2, category:ColliderType.Block.rawValue)
        
        guard let floor = scene.rootNode.childNode(withName: "Floor-Level", recursively: true) else { return }
        floor.physicsBody = SCNPhysicsBody.static()
        floor.physicsBody?.categoryBitMask = ColliderType.Ground.rawValue
        floor.physicsBody?.contactTestBitMask = 0
    }
    
    private func addPhysicsShape(node:SCNNode, category:Int) {
        let physicsShape = SCNPhysicsShape(geometry: node.geometry!, options: [SCNPhysicsShape.Option.type:SCNPhysicsShape.ShapeType.concavePolyhedron])
        node.physicsBody = SCNPhysicsBody(type: .static, shape: physicsShape)
        node.physicsBody?.categoryBitMask = category
        node.physicsBody?.contactTestBitMask = ColliderType.Player.rawValue
    }
    
    func setupAudio() {
        // Get an arbitrary node to attach the sounds to.
        let node = scene.rootNode
        
        // ambience
        if let audioSource = SCNAudioSource(named: "Art.scnassets/sounds/ambience.mp3") {
            audioSource.loops = true
            audioSource.volume = 0.8
            audioSource.isPositional = false
            audioSource.shouldStream = true
            node.addAudioPlayer(SCNAudioPlayer(source: audioSource))
        }
        
    }

    #if os(OSX)
    override func keyDown(with theEvent: NSEvent) {
        let key = theEvent.keyCode
        switch(key) {
        case KeyboardDirection.left.rawValue:
            if !theEvent.isARepeat {
                player!.changeRotationBy(angleInRadians: Float.pi/4)
            }
            break
        case KeyboardDirection.right.rawValue:
            if !theEvent.isARepeat {
                player!.changeRotationBy(angleInRadians: -Float.pi/4)
            }
            break
        case KeyboardDirection.down.rawValue:
            if !theEvent.isARepeat {
                player!.changeRotationBy(angleInRadians: Float.pi)
            }
            break
        case KeyboardDirection.up.rawValue:
            player!.setDirection(player!.getNode().orientationVector())
            break
        case KeyboardEvents.SPACEBAR:
            print("SPACEBAR")
            self.setupAudio()

            break
        case KeyboardEvents.ESCAPE:
            toggleCamera = !toggleCamera
            break
        default:
            break
        }
    }
    
    override func keyUp(with theEvent: NSEvent) {
        player!.setDirection(SCNVector3Zero)
    }
    
    #else
    override func tapped(gesture: UITapGestureRecognizer) {
        var touchLocation: CGPoint = gesture.location(in: gesture.view)
        touchLocation = sceneView.overlaySKScene!.convertPoint(fromView: touchLocation)
        let node:SKNode = sceneView.overlaySKScene!.atPoint(touchLocation)
        print("TAPPED NODE:\(node.name)")
        
        if let tappedNodeName = node.name {
            if (tappedNodeName == "attackNode") {
                self.attack()
            } else if (tappedNodeName == "dpad" ) {
                player!.setDirection(player!.getNode().orientationVector())
            }
        } else {
             player!.setDirection(SCNVector3Zero)
        }
        
    }
    
    override func leftGesture(gesture:UISwipeGestureRecognizer) {
        player!.changeRotationBy(angleInRadians: Float.pi/4)

    }
    override func rightGesture(gesture:UISwipeGestureRecognizer) {
        player!.changeRotationBy(angleInRadians: -Float.pi/4)

    }
    override func downGesture(gesture:UISwipeGestureRecognizer) {
        player!.changeRotationBy(angleInRadians: Float.pi)

    }
    
    
    func attack() {

        print("Handling attack touch")
    }
    
    #endif
}
