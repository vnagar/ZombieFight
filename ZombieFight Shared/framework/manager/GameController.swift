//
//  GameController.swift
//  ZombieFight Shared
//
//  Created by Vivek Nagar on 2/20/18.
//  Copyright © 2018 Vivek Nagar. All rights reserved.
//

import SceneKit
import SpriteKit

class GameController: NSObject, SCNSceneRendererDelegate {
    
    init(sceneRenderer renderer: SCNSceneRenderer) {
        super.init()

        // Assign the SpriteKit overlay to the SceneKit view.
        let view = renderer as! SCNView
        let skScene = SKScene(size: CGSize(width: view.bounds.size.width, height:view.bounds.size.height))
        skScene.scaleMode = .resizeFill
        renderer.overlaySKScene = skScene
        
        let scenesManager = GameScenesManager.sharedInstance
        scenesManager.setView(view: view)
        scenesManager.setupLevels()
        
    }
    
}
