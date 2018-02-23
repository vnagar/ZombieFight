//
//  EnemyTarget.swift
//  ZombieFight
//
//  Created by Vivek Nagar on 2/22/18.
//  Copyright © 2018 Vivek Nagar. All rights reserved.
//

import SceneKit

// Describes a potential target to the AI entity
class EnemyTarget {
    private var _type:EnemyTargetType
    // collision node of target
    private var _collider:SCNNode?
    //position of target
    private var _position:SCNVector3
    // distance to target
    private var _distance:Float
    //time target last seen
    private var _time:TimeInterval
    
    var type : EnemyTargetType { get { return _type } }
    var collider : SCNNode? { get { return _collider } }
    var position : SCNVector3 { get { return _position } }
    var distance : Float { get { return _distance } set { _distance = newValue }}
    var time : TimeInterval { get { return _time } }
    
    init() {
        _type = .None
        _collider = nil
        _position = SCNVector3Zero
        _distance = Float.infinity
        _time = 0.0
    }
    
    func setTarget(t:EnemyTargetType, c:SCNNode?, p:SCNVector3, d:Float) {
        _type = t
        _collider = c
        _position = p
        _distance = d
        _time = GameTime.getSystemTime()
    }
    
    func clear() {
        _type = .None
        _collider = nil
        _position = SCNVector3Zero
        _distance = Float.infinity
        _time = 0.0
    }
}
