//
//  EntityManager.swift
//  ZombieFight
//
//  Created by Vivek Nagar on 2/20/18.
//  Copyright © 2018 Vivek Nagar. All rights reserved.
//

import SceneKit

class EntityManager {
    static let sharedInstance = EntityManager()
    private var player:PlayerEntity?
    private var enemies = [EnemyEntity]()
    
    private init() {
    }
    
    func createPlayer() -> PlayerEntity {
        player = PlayerEntity(name:"Player")
        guard let playerEntity = player else { fatalError("Cannot create player") }
        
        return playerEntity
    }
    
    func createEnemies() -> [EnemyEntity] {
        let enemy = EnemyEntity(name:"Enemy1")
        enemies.append(enemy)
        
        return enemies
    }
    
    func update(time: GameTime) {
        player!.update(time:time)
        for enemy in enemies {
            enemy.update(time:time)
        }
    }
    
    func physicsUpdate(time: GameTime) {
        player!.physicsUpdate(time:time)
        for enemy in enemies {
            enemy.physicsUpdate(time:time)
        }
    }
    
}
