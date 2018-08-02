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
    var isBlocked: Bool = false
    
    init(model: GameModel, blocked: Bool) {
        
        self.isBlocked = blocked
        super.init(
            model: model,
            text: "",
            color: PaletteManager.cellBgColor())
        if blocked {
            block()
        }
    }
    
    @objc func addGameCell(cell: GameCell) {
        
        assert(self.gameCell == nil, "BgCell already contain game cell")
        
        self.gameCell = cell
        self.addChild(cell)
        self.gameCell?.zPosition = zPositions.bgCellZ.rawValue
    }
    
    @objc func removeGameCell() {
        self.gameCell?.removeFromParent()
        self.gameCell = nil
    }
    
    func block() {
        
        self.hexShape.removeFromParent()
        self.isBlocked = true
    }
    
    func unblock() {
        
        addChild(self.hexShape)
        self.isBlocked = false
    }
    
    func destination(to: BgCell) -> CGVector {
        return CGVector(from: position, to: to.position);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
