//
//  Constants.swift
//  ZombieFight
//
//  Created by Vivek Nagar on 2/20/18.
//  Copyright © 2018 Vivek Nagar. All rights reserved.
//

import SceneKit
import simd

#if os(iOS)
typealias SCNColor = UIColor
let namespace = "ZombieFight"
#else
typealias SCNColor = NSColor
let namespace = "ZombieFight"
#endif

@objc enum GameState :Int {
    case PreGame=0,
    InGame,
    Paused,
    LevelComplete,
    LevelFailed,
    PostGame
}

struct KeyboardEvents {
    static let SPACEBAR:UInt16 = 49
}

enum KeyboardDirection : UInt16 {
    case left   = 123
    case right  = 124
    case down   = 125
    case up     = 126
    
    var vector : float2 {
        switch self {
        case .up:    return float2( 0, -1)
        case .down:  return float2( 0,  1)
        case .left:  return float2(-1,  0)
        case .right: return float2( 1,  0)
        }
    }
}
