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
    private var navigationMesh:NavigationMesh?
    private var player:PlayerEntity?
    private var playerStateMachine:PlayerStateMachine?
    private var enemyStateMachines = [SCNNode:EnemyStateMachine]()
    private var enemies = [EnemyEntity]()
    
    private init() {
    }
    
    func setNavigationMesh(_ navmesh:NavigationMesh) {
        navigationMesh = navmesh
    }
    
    func getNavigationMesh() -> NavigationMesh? {
        return self.navigationMesh
    }
    
    func createPlayer() -> PlayerEntity {
        player = PlayerEntity(name:"Player")
        guard let playerEntity = player else { fatalError("Cannot create player") }
        
        let idleState = PlayerIdleState()
        let walkState = PlayerWalkState()
        playerStateMachine = PlayerStateMachine(owner:playerEntity, stateList:[idleState, walkState])
        
        return playerEntity
    }
    
    func createEnemies() -> [EnemyEntity] {
        
        let enemy = EnemyEntity(name:"Enemy1", baseName:"Art.scnassets/characters/zombie1/")
        enemies.append(enemy)

        let idleState = EnemyIdleState()
        let alertState = EnemyAlertedState()
        let patrolState = EnemyPatrolState()
        let attackState = EnemyAttackState()
        let pursuitState = EnemyPursuitState()
        let enemyStateMachine = EnemyStateMachine(owner:enemy, stateList:[idleState, alertState, patrolState, attackState, pursuitState])
        enemyStateMachines[enemy.getNode()] = enemyStateMachine
        enemyStateMachines[enemy.getPhysicsNode()] = enemyStateMachine
        enemyStateMachines[enemy.getSensorNode()] = enemyStateMachine

        return enemies
    }
    
    func update(time: GameTime) {
        playerStateMachine?.preupdate(time: time)
        player?.update(time:time)
        for enemy in enemies {
            let sm = enemyStateMachines[enemy.getNode()]
            sm?.preupdate(time: time)
            enemy.update(time:time)
        }
    }
    
    func physicsUpdate(time: GameTime) {
        playerStateMachine?.update(time: time)
        player?.physicsUpdate(time:time)
        for enemy in enemies {
            let sm = enemyStateMachines[enemy.getNode()]
            sm?.update(time: time)
            enemy.physicsUpdate(time:time)
        }
    }
    
    func clearEntities() {
        player?.destroy()
        for enemy in enemies {
            enemy.destroy()
        }
        enemies.removeAll()
    }
    
    func registerAIStateMachine(collider:SCNNode, stateMachine:EnemyStateMachine) {
        if let _ = enemyStateMachines[collider] {
            print("collider \(collider) already exists")
        } else {
            enemyStateMachines[collider] = stateMachine
        }
    }
    
    func getAIStateMachine(collider:SCNNode) -> EnemyStateMachine? {
        if let val = enemyStateMachines[collider] {
            return val
        }
        return nil
    }
    
    func clearDatabase() {
        enemyStateMachines.removeAll()
    }
}
