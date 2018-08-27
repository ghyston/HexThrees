//
//  GameScene.swift
//  HexThrees Shared
//
//  Created by Ilja Stepanow on 10.04.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import SpriteKit
import GameKit

class GameScene: SKScene {
    
    class func newGameScene() -> GameScene {
        
        guard let scene = SKScene(fileNamed: "GameScene") as? GameScene else {
            print("Failed to load GameScene.sks")
            abort()
        }
        
        scene.scaleMode = .resizeFill
        
        return scene
    }
    
    func add(entity: GKEntity, _ layer: zPositions) {
        
        guard let nodeCmpt = entity.component(ofType: GKSKNodeComponent.self) else {
            return
        }
        
        nodeCmpt.node.zPosition = zPositions.bgCellZ.rawValue
        self.addChild(nodeCmpt.node)
    }
    
    func remove(entity: GKEntity) {
        
        guard let nodeCmpt = entity.component(ofType: GKSKNodeComponent.self) else {
            return
        }
        
        if nodeCmpt.node.inParentHierarchy(self) {
            
           nodeCmpt.node.removeFromParent()
        }
    }
    
    
    override func didMove(to view: SKView) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
}
