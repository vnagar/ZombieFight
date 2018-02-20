//
//  GameLevel2.swift
//  Adventure
//
//  Created by Vivek Nagar on 1/18/18.
//  Copyright © 2018 Vivek Nagar. All rights reserved.
//

import SceneKit
import SpriteKit
import simd

class GameLevel2 : GameLevel {
    var previousTime = 0.0
    var deltaTime = 0.0
    
    override init() {
        super.init()
        previousTime = 0.0
        deltaTime = 0.0
    }
    
    override func createLevel(sceneView:SCNView) -> SCNScene {
        self.sceneView = sceneView
        self.scene = SCNScene(named: "Art.scnassets/ship.scn")!
        
        return scene
    }
    
    override func startLevel() {
        super.startLevel()
        self.addHUD()
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
