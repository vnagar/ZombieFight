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
    var previousTime = 0.0
    var deltaTime = 0.0
    
    override init() {
        super.init()
        previousTime = 0.0
        deltaTime = 0.0
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
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didSimulatePhysicsAtTime time: TimeInterval) {
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
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 10, z: 15)
        cameraNode.rotation = SCNVector4(1.0, 0.0, 0.0, -Double.pi/4)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = SCNColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
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
