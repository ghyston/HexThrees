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
    var bonus: BonusNode?
    var isBlocked: Bool = false
    let coord: AxialCoord
    
    //@todo: make it lazy static (to init once per game)
    var blockShader : SKShader
    
    init(model: GameModel, blocked: Bool, coord: AxialCoord) {
        
        self.isBlocked = blocked
        self.blockShader = SKShader.init(fileNamed: "gridDervative.fsh")
        self.coord = coord
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
        
        self.hexShape.fillShader = blockShader
        self.isBlocked = true
    }
    
    func unblock() {
        
        self.hexShape.fillShader = nil
        self.isBlocked = false
    }
    
    func destination(to: BgCell) -> CGVector {
        return CGVector(from: position, to: to.position);
    }
    
    func addBonus(_ bonusNode: BonusNode) {
        
        self.bonus = bonusNode
        self.bonus?.zPosition = 10.0
        addChild(self.bonus!)
    }
    
    func removeBonusWithDisposeAnimation() {
        
        self.bonus?.playDisposeAnimationAndRemoveFromParent()
        self.bonus = nil
    }
    
    func removeBonusWithPickingAnimation(_ delay: Double) {
        
        self.bonus?.playPickingAnimationAndRemoveFromParent(delay: delay)
        self.bonus = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
