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
    
    func run(scene: SKScene, coord: AxialCoord, isBlocked: Bool = false) {
        
        let hexCell = BgCell(model: self.gameModel, blocked: isBlocked)
        
        //hexCell.updateText(text: "\(coord.c, coord.r)") //For debug purposes
        
        hexCell.position = self.gameModel.geometry.ToScreenCoord(coord)
        hexCell.position.y += 70.0 //@todo: move to screen calculator!
        
        self.gameModel.bgHexes.append(hexCell) //@todo: not just append, but use coordinates
        scene.addChild(hexCell)
        
    }
    
}
