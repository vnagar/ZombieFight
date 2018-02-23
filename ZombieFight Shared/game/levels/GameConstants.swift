//
//  GameConstants.swift
//  ZombieFight iOS
//
//  Created by Vivek Nagar on 2/20/18.
//  Copyright © 2018 Vivek Nagar. All rights reserved.
//

import Foundation

enum ColliderType: Int {
    case Bullet = 4
    case Player = 8
    case Enemy = 16
    case Wall = 32
    case Block = 64
    case Ground = 128
    case Door = 256
    case PowerUp = 512
    case Obstacle = 1024
}

enum PlayerAnimationState : Int {
    case Idle = 0,
    Walk,
    Run,
    Jump,
    Kick,
    Punch,
    Shoot,
    Die,
    LeftTurn,
    RightTurn
}

enum EnemyAnimationState : Int {
    case Idle = 0,
    Alert,
    Walk,
    Run,
    Attack,
    LeftTurn,
    RightTurn,
    Hit,
    Scream,
    Die
}

enum EnemyStateType : Int {
    case None = 0, Idle, Alerted, Patrol, Attack, Feeding, Pursuit, Dead
}

enum PlayerStateType : Int {
    case None = 0, Idle, Walk, Run, Jump, Kick, Punch, Shoot, Dead
}

enum EnemyTargetType : Int {
    case None = 0, Waypoint, Visual_Player, Visual_Light, Visual_Food, Audio
}

struct GameConstants {
    struct Player {
        static let speedFactor = Float(10.0)
        static let idleAnimationKey = "idleAnimationKey"
        static let walkAnimationKey = "walkAnimationKey"
        static let punchAnimationKey = "punchAnimationKey"
        static let kickAnimationKey = "kickAnimationKey"
        static let shootAnimationKey = "shootAnimationKey"
        static let dieAnimationKey = "dieAnimationKey"
        static let runAnimationKey = "runAnimationKey"
        static let jumpAnimationKey = "jumpAnimationKey"
        static let leftTurnAnimationKey = "leftTurnAnimationKey"
        static let rightTurnAnimationKey = "rightTurnAnimationKey"

        
        // These identifiers are in the dae file for the skeleton node
        static let idleAnimationIdentifier = "idleAnimation"
        static let walkAnimationIdentifier = "walkAnimation"
        static let punchAnimationIdentifier = "punchAnimation"
        static let kickAnimationIdentifier = "kickAnimation"
        static let shootAnimationIdentifier = "shootAnimation"
        static let dieAnimationIdentifier = "dieAnimation"
        static let runAnimationIdentifier = "runAnimation"
        static let jumpAnimationIdentifier = "jumpAnimation"
        static let leftTurnAnimationIdentifier = "leftTurnAnimation"
        static let rightTurnAnimationIdentifier = "rightTurnAnimation"

    }
    struct Enemy {
        static let speedFactor = Float(5.0)
        static let idleAnimationKey = "idleAnimationKey"
        static let walkAnimationKey = "walkAnimationKey"
        static let alertedAnimationKey = "alertedAnimationKey"
        static let attackAnimationKey = "attackAnimationKey"
        static let hitAnimationKey = "hitAnimationKey"
        static let dieAnimationKey = "dieAnimationKey"
        static let runAnimationKey = "runAnimationKey"
        static let screamAnimationKey = "screamAnimationKey"
        static let leftTurnAnimationKey = "leftTurnAnimationKey"
        static let rightTurnAnimationKey = "rightTurnAnimationKey"
        
        
        // These identifiers are in the dae file for the skeleton node
        static let idleAnimationIdentifier = "idleAnimation"
        static let walkAnimationIdentifier = "walkAnimation"
        static let alertedAnimationIdentifier = "alertedAnimation"
        static let attackAnimationIdentifier = "attackAnimation"
        static let hitAnimationIdentifier = "hitAnimation"
        static let dieAnimationIdentifier = "dieAnimation"
        static let runAnimationIdentifier = "runAnimation"
        static let screamAnimationIdentifier = "screamAnimation"
        static let leftTurnAnimationIdentifier = "leftTurnAnimation"
        static let rightTurnAnimationIdentifier = "rightTurnAnimation"
    }
    struct MainMenu {
        static let levelName1 = "Level 1"
        static let levelName2 = "Level 2"
        static let levelName3 = "Level 3"
    }
    struct LevelCompleteMenu {
        static let labelName = "Level Complete"
        static let replayLabelName = "Next Level"
        static let mainMenuLabelName = "Main Menu"
    }
    struct LevelFailedMenu {
        static let labelName = "Level Failed"
        static let replayLabelName = "Replay Level"
        static let mainMenuLabelName = "Main Menu"
    }
}
