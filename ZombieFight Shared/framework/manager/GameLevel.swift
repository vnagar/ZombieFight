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
    internal var lastMousePosition = float2(0)
    func mouseDown(view:NSView, with theEvent: NSEvent) {
        lastMousePosition = float2(view.convert(theEvent.locationInWindow, from: nil))
    }
    
    func mouseUp(view:NSView, with theEvent: NSEvent) {
    }
    
    func mouseDragged(view:NSView, with theEvent: NSEvent) {
        let mousePosition = float2(view.convert(theEvent.locationInWindow, from: nil))
        panCamera(mousePosition - lastMousePosition)
        lastMousePosition = mousePosition
    }
    
    func keyDown(with theEvent: NSEvent) {
        if let _ = KeyboardDirection(rawValue: theEvent.keyCode) {
            if !theEvent.isARepeat {
            }
        } else {
            //print("Another key is down:\(theEvent.keyCode)")
            self.handleKeyEvent(event: theEvent.keyCode)
        }
    }
    
    func keyUp(with theEvent: NSEvent) {
        if let _ = KeyboardDirection(rawValue: theEvent.keyCode) {
            if !theEvent.isARepeat {
            }
        }
    }
    
    func handleKeyEvent(event:UInt16) {
        print("Subclasses should handle this event")
    }
    
    #else
    internal var padTouch: UITouch?
    internal var panningTouch: UITouch?
    
    func touchesBegan(touches: Set<UITouch>, with event: UIEvent?) {
        guard let hud = hudNode else {
            return
        }
        for touch in touches {
            let location:CGPoint = touch.location(in: hud.scene!)
            let node:SKNode = hud.scene!.atPoint(location)
    
            if hud.virtualDPadBounds().contains(location) {
                // We're in the dpad
                if padTouch == nil {
                    padTouch = touch
                }
            } else if let name = node.name { // Check if node name is not nil
                if (name == "attackNode") {
                    //NSNotificationCenter.defaultCenter().postNotificationName(Constants.GameEvents.ATTACK_ENEMY, object: nil)
                    self.handleTouchForAttackNode()
                }
                break
            } else if panningTouch == nil {
                panningTouch = touches.first
            }
    
            if padTouch != nil && panningTouch != nil {
                break // We already have what we need
            }
        }
    }
    
    func touchesMoved(touches: Set<UITouch>, with event: UIEvent?) {
        guard let hud = hudNode, let scene = hud.scene else {
            return
        }
        if let touch = panningTouch {
            let loc1 = touch.location(in: scene)
            let loc2 = touch.previousLocation(in: scene)
            let disp = CGPoint(x: (loc1.x-loc2.x), y: (loc1.y - loc2.y))
            let displacement = float2(SCNFloat(disp.x), SCNFloat(disp.y))
            panCamera(displacement)
        }
        if let touch = padTouch {
            let loc1 = touch.location(in: scene)
            let loc2 = touch.previousLocation(in: scene)
            let disp = CGPoint(x: (loc1.x-loc2.x), y: (loc1.y - loc2.y))
            if(abs(disp.x) > abs(disp.y)) {
                if(disp.x > 0) {
                } else if (disp.x < 0) {
                } else {
                }
            } else {
                if(disp.y > 0) {
                } else if (disp.y < 0) {
                } else {
                }
            }
        }
    }
    
    func commonTouchesEnded(touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = panningTouch {
            if touches.contains(touch) {
                panningTouch = nil
            }
        }
        if let touch = padTouch {
            if touches.contains(touch) || event?.touches(for: self.sceneView)?.contains(touch) == false {
                padTouch = nil
            }
        }
    }
    
    func touchesEnded(touches: Set<UITouch>, with event: UIEvent?) {
        commonTouchesEnded(touches: touches, with: event)
    }
    
    func handleTouchForAttackNode() {
        print("subclasses should handle this")
    }
    
    
    #endif
    
    func panCamera(_ direction: float2) {
        print("subclasses should handle this")
    }
    
    func startLevel() {
    }
    
    func pauseLevel() {
        print("subclasses should implement this")
    }
    
    
    func levelFailed() {
        print("subclasses should implement this")
        
    }
    
    func levelCompleted() {
        print("subclasses should implement this")
        
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
