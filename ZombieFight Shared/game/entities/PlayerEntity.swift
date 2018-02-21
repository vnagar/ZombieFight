//
//  PlayerEntity.swift
//  ZombieFight
//
//  Created by Vivek Nagar on 2/20/18.
//  Copyright © 2018 Vivek Nagar. All rights reserved.
//

import SceneKit

class PlayerEntity : Entity {
    private var name = ""
    private var node = SCNNode()
    
    init(name:String) {
        self.name = name
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getName() -> String {
        return self.name
    }
    
    func getNode() -> SCNNode {
        return self.node
    }
    
    func update(time:GameTime) {
    }
    
    func physicsUpdate(time: GameTime) {
    }
    
    func destroy() {
        node.removeFromParentNode()
    }
}
