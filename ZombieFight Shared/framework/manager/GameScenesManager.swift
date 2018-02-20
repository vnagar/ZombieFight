//
//  GameScenesManager.swift
//  Adventure
//
//  Created by Vivek Nagar on 1/18/18.
//  Copyright © 2018 Vivek Nagar. All rights reserved.
//

import SceneKit
import SpriteKit

class GameScenesManager {
    var score = 0
    var highScore = 0
    var lastScore = 0
    var levelNumber = 1
    var lives = 3
    
    let levelName = "GameLevel"
    var gameState = GameState.PreGame
    var scnView:SCNView?
    var gameLevels = [String]()
    var menuLevels = [String]()
    var currentLevel:GameLevel?
    var currentLevelIndex:Int = 0

    // Singleton
    static let sharedInstance = GameScenesManager()
    
    private init() {
        let defaults = UserDefaults.standard
        score = defaults.integer(forKey: "lastScore")
        highScore = defaults.integer(forKey: "highScore")
        levelNumber = defaults.integer(forKey:"levelNumber")
    }
    
    func setView(view:SCNView) {
        self.scnView = view
    }
    
    func saveState() {
        lastScore = score
        highScore = max(score, highScore)
        let defaults = UserDefaults.standard
        defaults.set(lastScore, forKey: "lastScore")
        defaults.set(highScore, forKey: "highScore")
        defaults.set(levelNumber, forKey: "levelNumber")
    }
    
    func reset() {
        score = 0
        lives = 3
    }
    
    func setupLevels() {
        guard let view = scnView else {
            fatalError("Scene View is not set")
        }
        menuLevels.append("GameLevelsMenu")
        menuLevels.append("LevelCompleteMenu")
        menuLevels.append("LevelFailedMenu")
        
        let numLevels = 2
        for levelIndex in 0...numLevels-1 {
            gameLevels.append(levelName + String(levelIndex))
        }
        view.scene = SCNScene()
        setGameState(gameState: .PreGame, levelIndex:0)
    }

    func setGameState(gameState:GameState, levelIndex:Int) {
        guard let view = self.scnView else {
            fatalError("Scene View is not set")
        }
        guard let overlay = view.overlaySKScene else {
            fatalError("No overlay scene found")
        }
        
        for child in overlay.children {
            child.removeFromParent()
        }
        
        switch(gameState) {
        case .PreGame:
            currentLevel = setupGameLevel(levelName:menuLevels[0])
            break
        case .InGame:
            currentLevelIndex = levelIndex
            if(currentLevelIndex < gameLevels.count) {
                currentLevel = setupGameLevel(levelName:gameLevels[currentLevelIndex])
            } else {
                // Past the last level - go to postgame
                setGameState(gameState: .PostGame, levelIndex:0)
                return
            }
            break
        case .PostGame:
            view.stop(self)
            break
        case .LevelComplete:
            currentLevel = setupGameLevel(levelName:menuLevels[1])
            break
        case .LevelFailed:
            currentLevel = setupGameLevel(levelName:menuLevels[2])
            break
        case .Paused:
            currentLevel!.pauseLevel()
            view.pause(self)
            break
        }
        self.gameState = gameState;
    }

    private func setupGameLevel(levelName:String) -> GameLevel {
        guard let view = scnView else {
            fatalError("Scene View is not set")
        }
        //print("My class is \(NSStringFromClass(GameScenesManager.self) as NSString)")
        let lName = namespace + "." + levelName
        let aClass = NSClassFromString(lName) as! NSObject.Type
        let level = aClass.init() as! GameLevel
        currentLevel = level
        
        let levelScene = currentLevel!.createLevel(sceneView: view)
        guard let scene = levelScene else { fatalError("Level could not create scene") }
        view.scene = scene
        view.delegate = currentLevel
        view.scene!.physicsWorld.contactDelegate = currentLevel
        
        self.transitionScene(scene:scene)
        currentLevel!.startLevel()
        view.play(self)
        view.loops = true
        
        return currentLevel!
    }

    private func transitionScene(scene:SCNScene) {
        let sceneTransition = SKTransition.moveIn(with: .right, duration: 1.0)
        guard let view = scnView else {
            fatalError("Scene View is not set")
        }
        view.present(scene, with: sceneTransition, incomingPointOfView:nil, completionHandler:nil)
    }

}
