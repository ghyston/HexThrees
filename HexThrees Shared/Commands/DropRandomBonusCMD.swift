//
//  DropRandomBonusCMD.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 27.08.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class DropRandomBonusCMD : GameCMD {
    
    private func cellForBonus(cell: BgCell) -> Bool {
        
        return
            cell.gameCell == nil &&
            cell.isBlocked == false &&
            cell.bonus == nil
    }
    
    override func run() {
        
        //@todo: add random generator with probabilities etc
        
        var freeCells = self.gameModel.getBgCells(compare: self.cellForBonus)
        
        guard freeCells.count > 0 else {
            return
        }
        
        let random = Int(arc4random()) % freeCells.count
        
        if(Int(arc4random()) % 2 == 1) {
            
            let bonusNode = BonusFabric.createLockBonus(gameModel: self.gameModel)
            freeCells[random].addBonus(bonusNode)
        }
        else {
            
            let bonusNode = BonusFabric.createUnlockBonus(gameModel: self.gameModel)
            freeCells[random].addBonus(bonusNode)
        }
    }
}
