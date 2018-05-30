//
//  BgCell.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 26.04.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

class BgCell: HexCell {
    
    var gameCell: GameCell?
    
    init(coord: AxialCoord, hexCalc: HexCalculator) {
        super.init(text: "\(coord.c, coord.r)", isGray: true)
        self.position = hexCalc.ToScreenCoord(coord)
    }
    
    @objc func addGameCell(cell: GameCell) {
        //@todo: throw, if already exist
        
        self.gameCell = cell
        self.addChild(cell)
        self.gameCell?.zPosition = 3
    }
    
    @objc func removeGameCell() {
        self.gameCell?.removeFromParent()
        self.gameCell = nil
    }
    
    func destination(to: BgCell) -> CGVector {
        //@todo: add extensions to CGVector.init(points diff)
        return CGVector(
            dx: to.position.x - position.x,
            dy: to.position.y - position.y)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
