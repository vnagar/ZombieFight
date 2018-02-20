//
//  GameLevelsMenu.swift
//  FirstPersonShooter
//
//  Created by Vivek Nagar on 7/29/16.
//  Copyright © 2016 Vivek Nagar. All rights reserved.
//

import SceneKit
import SpriteKit

class GameLevelsMenu : GameLevel {
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createLevel(sceneView:SCNView) -> SCNScene  {
        self.sceneView = sceneView
        scene = SCNScene()
        
        let size = self.sceneView.frame.size
        DispatchQueue.main.async {
            self.addMenuBlock(labelName:GameConstants.MainMenu.levelName1, position:CGPoint(x:size.width/2, y:size.height/2 + 80))
            self.addMenuBlock(labelName:GameConstants.MainMenu.levelName2, position:CGPoint(x:size.width/2, y:size.height/2))
            self.addMenuBlock(labelName:GameConstants.MainMenu.levelName3, position:CGPoint(x:size.width/2, y:size.height/2 - 80))
        }
        return scene
    }
    
    #if os(OSX)
    override func mouseDown(view:NSView, with theEvent: NSEvent) {
        // check what nodes are clicked
        let p = sceneView.convert(theEvent.locationInWindow, from: nil)
        self.handleSelection(view: sceneView, location:p)

    }
    
    #else
    override func touchesBegan(touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let p = touch.location(in: sceneView.overlaySKScene!)
            self.handleSelection(view: sceneView, location:p)
        }
    }
    
    #endif
    
    private func handleSelection(view:SCNView, location:CGPoint) {
        let node:SKNode = sceneView.overlaySKScene!.atPoint(location)

        if (node.name == GameConstants.MainMenu.levelName1) {
            GameScenesManager.sharedInstance.setGameState(gameState: .InGame, levelIndex:0)
        } else if(node.name == GameConstants.MainMenu.levelName2) {
            GameScenesManager.sharedInstance.setGameState(gameState: .InGame, levelIndex:1)
        } else if(node.name == GameConstants.MainMenu.levelName3) {
            GameScenesManager.sharedInstance.setGameState(gameState: .InGame, levelIndex:2)
        }

    }
    
    private func addMenuBlock(labelName:String, position:CGPoint) {
        let myLabel = MenuUtils.labelWithText(text: labelName, textSize: 40, fontColor:SKColor.yellow)
        myLabel.position = position
        self.sceneView.overlaySKScene!.addChild(myLabel)
    }

}
