//
//  GameView.swift
//  Raven
//
//  Created by Vivek Nagar on 2/7/18.
//  Copyright © 2018 Vivek Nagar. All rights reserved.
//

import Foundation
import SpriteKit
import SceneKit


class GameView : SCNView {
    #if os(macOS)
    
    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        setup2DOverlay()
    }
    
    override func setFrameSize(_ newSize: NSSize) {
        super.setFrameSize(newSize)
    }
    
    override func keyDown(with theEvent: NSEvent) {
        guard let _ = GameScenesManager.sharedInstance.currentLevel?.keyDown(with: theEvent) else {
            super.keyDown(with: theEvent)
            return
        }
    }
    
    override func keyUp(with theEvent: NSEvent) {
        guard let _ = GameScenesManager.sharedInstance.currentLevel?.keyUp(with: theEvent) else {
            super.keyUp(with: theEvent)
            return
        }
    }
    
     override func mouseDown(with theEvent: NSEvent) {
        guard let _ = GameScenesManager.sharedInstance.currentLevel?.mouseDown(view:self, with: theEvent) else {
            super.mouseDown(with: theEvent)
            return
        }
     }
 
     override func mouseUp(with theEvent: NSEvent) {
        guard let _ = GameScenesManager.sharedInstance.currentLevel?.mouseUp(view:self, with: theEvent) else {
            super.mouseUp(with: theEvent)
            return
        }
     }
 
     override func mouseDragged(with theEvent: NSEvent) {
        guard let _ = GameScenesManager.sharedInstance.currentLevel?.mouseDragged(view:self, with: theEvent) else {
            super.mouseDragged(with: theEvent)
            return
        }
     }

    #else
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup2DOverlay()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let _ = GameScenesManager.sharedInstance.currentLevel?.touchesBegan(touches: touches as Set<UITouch>, with:event) else {
            super.touchesBegan(touches as Set<UITouch>, with:event)
            return
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let _ = GameScenesManager.sharedInstance.currentLevel?.touchesMoved(touches: touches as Set<UITouch>, with:event) else {
            super.touchesMoved(touches as Set<UITouch>, with:event)
            return
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let _ = GameScenesManager.sharedInstance.currentLevel?.touchesEnded(touches: touches as Set<UITouch>, with:event) else {
            super.touchesEnded(touches as Set<UITouch>, with:event)
            return
        }
    }
    
    #endif
    
    
    private func setup2DOverlay() {
        //Any further customization.
        self.debugOptions = SCNDebugOptions.showPhysicsShapes
    }
}
