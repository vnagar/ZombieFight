//
//  GameLevel.swift
//  ZombieFight
//
//  Created by Vivek Nagar on 2/20/18.
//  Copyright © 2018 Vivek Nagar. All rights reserved.
//

import SceneKit
import SpriteKit

class GameLevel : NSObject, SCNSceneRendererDelegate, SCNPhysicsContactDelegate {
    var sceneView = SCNView()
    var scene = SCNScene()
    var hudNode:HUDNode?
    
    override init() {
        super.init()
    }
    
    func createLevel(sceneView:SCNView) -> SCNScene? {
        fatalError("Subclasses must implement createLevel and override it")
    }
    
    //Input Handling (keyboard/mouse/touches/Gamepad)
    #if os(OSX)
    func mouseDown(view:NSView, with theEvent: NSEvent) {
    }
    
    func mouseUp(view:NSView, with theEvent: NSEvent) {
    }
    
    func mouseDragged(view:NSView, with theEvent: NSEvent) {
    }
    
    func keyDown(with theEvent: NSEvent) {
    }
    
    func keyUp(with theEvent: NSEvent) {
    }
    
    
    #else
    internal var padTouch: UITouch?
    internal var panningTouch: UITouch?
    
    func leftGesture(gesture:UISwipeGestureRecognizer) {
        
    }
    func rightGesture(gesture:UISwipeGestureRecognizer) {
        
    }
    func downGesture(gesture:UISwipeGestureRecognizer) {
        
    }
    func tapped(gesture:UITapGestureRecognizer) {
        
    }
    
    #endif
    
    func startLevel() {
    }
    
    func pauseLevel() {
        print("subclasses should implement pauseLevel")
    }
    
    func levelFailed() {
        print("subclasses should implement levelFailed")
        
    }
    
    func levelCompleted() {
        print("subclasses should implement levelCompleted")
        
    }
    
    func addHUD() {
        guard let overlayScene = sceneView.overlaySKScene else {
            print("No overlay scene")
            return
        }
        self.hudNode = HUDNode(scene:overlayScene, size: overlayScene.size)
        guard let hud = self.hudNode else {
            return
        }
        overlayScene.addChild(hud)
    }
    
    func cleanupScene() {
        // Other cleanup needed - audio listeners etc
        for child in scene.rootNode.childNodes {
            child.removeFromParentNode()
        }
    }
}
