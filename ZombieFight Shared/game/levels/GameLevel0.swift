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
        self.scene = SCNScene(named: "Art.scnassets/ship.scn")!
        
        return scene
    }
    
    override func startLevel() {
        super.startLevel()
        self.addHUD()
    }
    
    #if os(OSX)
    override func handleKeyEvent(event: UInt16) {
        switch event {
            case KeyboardEvents.SPACEBAR:
                print("keyboard event:\(event)")
                break
            default:
                break
        }
    }
    
    #else
    override func handleTouchForAttackNode() {
        print("Handling attack touch")
    }
    
    #endif
}
