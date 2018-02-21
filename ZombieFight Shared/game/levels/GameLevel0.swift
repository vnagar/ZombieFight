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
    private var toggleCamera = false
    private var mainCameraNode = SCNNode()
    private var currentCameraNode = SCNNode()
    private var playerCameraNode = SCNNode()
    private let playerSpawnPoint = SCNVector3(-6.0, 0.0, 5.0)
    let gameTime = GameTime()
    
    override init() {
        super.init()
    }
    
    override func createLevel(sceneView:SCNView) -> SCNScene {
        self.sceneView = sceneView
        //self.scene = SCNScene(named: "Art.scnassets/ship.scn")!
        self.scene = SCNScene(named: "Art.scnassets/models/bunker.dae")!
        if let navmeshNode = scene.rootNode.childNode(withName: "Navmesh", recursively: true) {
            let _ = NavigationMesh(scene: scene, node: navmeshNode)
            navmeshNode.removeFromParentNode()
        } else {
            print("Cannot find navigation mesh in scene")
        }
        
        return scene
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
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
    }
    
    func physicsWorld(_ world: SCNPhysicsWorld, didUpdate contact: SCNPhysicsContact) {
    }
    
    func physicsWorld(_ world: SCNPhysicsWorld, didEnd contact: SCNPhysicsContact) {
    }
    
    override func startLevel() {
        super.startLevel()
        self.addHUD()
        
        // create and add a camera to the scene
        mainCameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(mainCameraNode)
        
        // place the camera
        mainCameraNode.position = SCNVector3(x: 0, y: 10, z: 15)
        mainCameraNode.rotation = SCNVector4(1.0, 0.0, 0.0, -Double.pi/4)
        currentCameraNode = mainCameraNode
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = SCNColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
        
        let player = EntityManager.sharedInstance.createPlayer()
        scene.rootNode.addChildNode(player.getNode())
        playerCameraNode = player.getCameraNode()
        player.getNode().position = playerSpawnPoint
        player.getNode().eulerAngles = SCNVector3(0.0, Double.pi, 0.0)
        
        let enemies = EntityManager.sharedInstance.createEnemies()
        for enemy in enemies {
            scene.rootNode.addChildNode(enemy.getNode())
        }
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
    
    #if os(OSX)
    override func keyDown(with theEvent: NSEvent) {
        let key = theEvent.keyCode
        switch(key) {
        case KeyboardDirection.left.rawValue:
            if !theEvent.isARepeat {
            }
            break
        case KeyboardDirection.right.rawValue:
            if !theEvent.isARepeat {
            }
            break
        case KeyboardDirection.down.rawValue:
            if !theEvent.isARepeat {
            }
            break
        case KeyboardDirection.up.rawValue:
            break
        case KeyboardEvents.SPACEBAR:
            print("SPACEBAR")
            break
        case KeyboardEvents.ESCAPE:
            toggleCamera = !toggleCamera
            break
        default:
            break
        }
    }
    
    override func keyUp(with theEvent: NSEvent) {
    }
    
    #else
    override func handleTouchForAttackNode() {
        print("Handling attack touch")
    }
    
    #endif
}
