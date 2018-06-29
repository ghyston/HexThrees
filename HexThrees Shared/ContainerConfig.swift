//
//  ContainerConfig.swift
//  Ravens macOS
//
//  Created by Ilja Stepanow on 16.11.17.
//  Copyright © 2017 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

class ContainerConfig {
    
    static var instance : Container = {
        var container = Container()
        Configure(&container)
        return container
    }()
    
    static func Configure(_ container : inout Container) {
        
        /*let scene = GameScene.newGameScene()
        let entityManager = RavenEntityManager(scene)
        let gamePlay = RavensGameplay(entityManager)
        let inputSystem = RavensInputSystem(gamePlay: gamePlay, entityManager: entityManager)
        let eventSysten = EventSystem()
        
        container.Register(scene as SKScene)
        container.Register(entityManager as EntityManager)
        container.Register(gamePlay as GamePlay)
        container.Register(inputSystem as InputSystem)
        container.Register(eventSysten as IEventSystem)*/
    }
}
