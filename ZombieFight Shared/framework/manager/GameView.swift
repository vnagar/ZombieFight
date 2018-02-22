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
    
    @objc func leftGesture(_ sender: UISwipeGestureRecognizer) {
        guard let _ = GameScenesManager.sharedInstance.currentLevel?.leftGesture(gesture:sender) else {
            return
        }
    }
    @objc func rightGesture(_ sender: UISwipeGestureRecognizer) {
        guard let _ = GameScenesManager.sharedInstance.currentLevel?.rightGesture(gesture:sender) else {
            return
        }
    }
    @objc func downGesture(_ sender: UISwipeGestureRecognizer) {
        guard let _ = GameScenesManager.sharedInstance.currentLevel?.downGesture(gesture:sender) else {
            return
        }
    }
    @objc func tapGesture(_ sender: UITapGestureRecognizer) {
        guard let _ = GameScenesManager.sharedInstance.currentLevel?.tapped(gesture:sender) else {
            return
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.isUserInteractionEnabled = true
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(rightGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(leftGesture(_:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.addGestureRecognizer(swipeLeft)
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(downGesture(_:)))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.addGestureRecognizer(swipeDown)
        
        let tapGesture = UITapGestureRecognizer(target:self, action: #selector(tapGesture(_:)))
        self.addGestureRecognizer(tapGesture)
    }
    
    #endif
    
    
    private func setup2DOverlay() {
        //Any further customization.
        self.debugOptions = SCNDebugOptions.showPhysicsShapes
    }
}
