//
//  LevelFailedMenu.swift
//  FirstPersonShooter
//
//  Created by Vivek Nagar on 7/29/16.
//  Copyright © 2016 Vivek Nagar. All rights reserved.
//

import SceneKit
import SpriteKit

class LevelCompleteMenu : GameLevel {
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createLevel(sceneView:SCNView) -> SCNScene  {
        self.sceneView = sceneView
        self.scene = SCNScene()
        
        let size = self.sceneView.frame.size
        self.addMenuBlock(labelName:GameConstants.LevelCompleteMenu.labelName, textSize:40, position:CGPoint(x:size.width/2, y:size.height/2 + 40))
        self.addMenuBlock(labelName:GameConstants.LevelCompleteMenu.replayLabelName, textSize:20, position:CGPoint(x:size.width/2, y:size.height/2))
        self.addMenuBlock(labelName:GameConstants.LevelCompleteMenu.mainMenuLabelName, textSize:20, position:CGPoint(x:size.width/2, y:size.height/2 - 40))

        return scene
    }
    
    #if os(OSX)
    override func mouseDown(view:NSView, with theEvent: NSEvent) {
        // check what nodes are clicked
        let p = sceneView.convert(theEvent.locationInWindow, from: nil)
        self.handleSelection(view: sceneView, location:p)
    }
    
    
    #else
    override func tapped(gesture: UITapGestureRecognizer) {
        var touchLocation: CGPoint = gesture.location(in: gesture.view)
        touchLocation = sceneView.overlaySKScene!.convertPoint(fromView: touchLocation)
        self.handleSelection(view: sceneView, location:touchLocation)
    }
    
    #endif
    
    private func handleSelection(view:SCNView, location:CGPoint) {
        let node:SKNode = sceneView.overlaySKScene!.atPoint(location)
        
        let levelIndex = GameScenesManager.sharedInstance.currentLevelIndex
        if (node.name == GameConstants.LevelCompleteMenu.replayLabelName) {
            GameScenesManager.sharedInstance.setGameState(gameState: .InGame, levelIndex:levelIndex+1)
        } else if(node.name == GameConstants.LevelCompleteMenu.mainMenuLabelName) {
            GameScenesManager.sharedInstance.setGameState(gameState: .PreGame, levelIndex:levelIndex)
        } else {
            print("Unknown node hit")
        }
    }

    private func addMenuBlock(labelName:String, textSize:CGFloat, position:CGPoint) {
        let myLabel = MenuUtils.labelWithText(text: labelName, textSize: textSize, fontColor:SKColor.yellow)
        myLabel.position = position
        self.sceneView.overlaySKScene!.addChild(myLabel)
    }
}
