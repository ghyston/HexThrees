//
//  EntityManager.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 26.08.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation
import GameKit

protocol EntityManager {
    
    //@todo: better to remove properties
    var entities : Set<GKEntity> { get set }
    
    //var touchComponentSystem : TouchComponentSystem { get set }
    //var selectComponentSystem : SelectorComponentSystem { get set }
    
    //@todo: hack!
    //func getMoveComponentSystem() -> GKComponentSystem<MoveComponent>
    
    func add(entity: GKEntity)
    func remove(entity: GKEntity)
    func update(_ deltaTime: CFTimeInterval)
}

class HexEntityManager : EntityManager {
    
    var entities = Set<GKEntity>()
    lazy var componentSystems: [GKComponentSystem] = {
        
        return []
            /*GKComponentSystem(componentClass: SpriteComponent.self),
            GKComponentSystem(componentClass: MoveComponent.self),
            GKComponentSystem(componentClass: DescriptionComponent.self)]*/
    }()
    
    var entitiesToRemove = Set<GKEntity>()
    
    init(_ gameScene : GameScene)
    {
        //self.scene = gameScene// ContainerConfig.instance.Resolve()
        //print("EntityManager init")
    }
    
    deinit {
        //print("EntityManager deinit")
    }
    
    func add(entity: GKEntity) {
        
        self.entities.insert(entity)
        
        /*if let node = entity.component(ofType: NodeComponent.self)?.node {
            self.scene.rootNode.addChild(node)
        }*/
        
        for componentSystem in componentSystems
        {
            componentSystem.addComponent(foundIn: entity)
            //touchComponentSystem.addComponent(foundIn : entity)
            //selectComponentSystem.addComponent(foundIn: entity)
        }
    }
    
    func remove(entity: GKEntity) {
        
        /*if let node = entity.component(ofType: NodeComponent.self)?.node {
            self.scene.removeChildren(in: [node])
        }*/
        
        entities.remove(entity)
        entitiesToRemove.insert(entity)
    }
    
    func update(_ deltaTime: CFTimeInterval)
    {
        for componentSystem in componentSystems
        {
            componentSystem.update(deltaTime: deltaTime)
            //touchComponentSystem.update(deltaTime: deltaTime)
        }
        
        for removedEntity in entitiesToRemove
        {
            for componentSystem in componentSystems
            {
                componentSystem.removeComponent(foundIn: removedEntity)
                //touchComponentSystem.removeComponent(foundIn: removedEntity)
                //selectComponentSystem.removeComponent(foundIn: removedEntity)
            }
        }
        entitiesToRemove.removeAll()
    }
    
}
