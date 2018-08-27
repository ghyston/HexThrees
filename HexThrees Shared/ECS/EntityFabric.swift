//
//  EntityFabric.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 26.08.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation
import GameKit

protocol HexThreesEntityFabric {
    
    static func createBgCell(coord: AxialCoord, isBlocked: Bool) -> GKEntity
    static func createPlCell(coordinates: CGPoint) -> GKEntity
    static func createBonusCell(coordinates: CGPoint) -> GKEntity
    
}

class EntityFabric : HexThreesEntityFabric {
    
    static func createBgCell(_ coord: AxialCoord, _ isBlocked: Bool) -> GKEntity {
        
        let entity = GKEntity()
        
        //@todo: do not pass model directly, calc geometry here?
        let gameModel = ContainerConfig.instance.resolve() as GameModel
        
        let hexNode = HexCell(
            model: gameModel,
            text: "", //@todo: make label lazy
            color: PaletteManager.cellBgColor())
        hexNode.position = gameModel.geometry.ToScreenCoord(coord)
        
        let nodeCmp = GKSKNodeComponent(node: hexNode)
        entity.addComponent(nodeCmp)
        
        let gridPosCmpt = GameGridPositionComponent(coord)
        entity.addComponent(gridPosCmpt)
        
        let contentCmpt = ContentComponent()
        entity.addComponent(contentCmpt)
        
        return entity
    }
    
    static func createPlCell(coordinates: CGPoint) -> GKEntity {
        
        let entity = GKEntity()
        
        let gameModel = ContainerConfig.instance.resolve() as GameModel
        
        let hexNode = PlCellNode(
            model: gameModel,
            val: 0)
        
        let nodeCmp = GKSKNodeComponent(node: hexNode)
        entity.addComponent(nodeCmp)
        
        return entity
    }
    
    static func createBonusCell(coordinates: CGPoint) -> GKEntity {
        
        //@todo
        return GKEntity()
    }
    
    
}
