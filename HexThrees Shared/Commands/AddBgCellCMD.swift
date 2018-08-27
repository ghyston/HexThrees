//
//  AddBgCellCMD.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 07.06.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

class AddBgCellCMD : GameCMD {
    
    func run(scene: GameScene, coord: AxialCoord, isBlocked: Bool = false) {
        
        let bgCell = EntityFabric.createBgCell(coord, isBlocked)
        let manager = ContainerConfig.instance.resolve() as EntityManager
        
        manager.add(entity: bgCell)
        scene.add(entity: bgCell, zPositions.bgCellZ)
        
        /*let hexCell = BgCell(model: self.gameModel, blocked: isBlocked)
        hexCell.position = self.gameModel.geometry.ToScreenCoord(coord)
        self.gameModel.bgHexes.append(hexCell) //@todo: not just append, but use coordinates
        scene.addChild(hexCell)*/
        
    }
    
}
