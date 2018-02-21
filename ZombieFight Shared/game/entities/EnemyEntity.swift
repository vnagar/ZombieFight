//
//  EnemyEntity.swift
//  ZombieFight
//
//  Created by Vivek Nagar on 2/20/18.
//  Copyright © 2018 Vivek Nagar. All rights reserved.
//

import SceneKit

class EnemyEntity : Entity {
    private var name = ""
    
    init(name:String) {
        self.name = name
    }
    
    func getName() -> String {
        return name
    }
    
    func update(time:GameTime) {
        
    }
    
    func physicsUpdate(time: GameTime) {
        
    }
}
