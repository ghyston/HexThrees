//
//  MarkRandomCellAsBlockedCMD.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 20.06.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class BlockRandomCellCMD : GameCMD {
    
    private func dontHaveGameCellAndBonuses (cell: BgCell) -> Bool {
        
        return
            cell.gameCell == nil &&
                !cell.isBlocked &&
                cell.bonus == nil
    }
    
    private func dontContainGameCell (cell: BgCell) -> Bool {
        
        return
            cell.gameCell == nil &&
            !cell.isBlocked
    }
    
    override func run() {
        
        var freeCells = gameModel.hasBgCells(compare: self.dontHaveGameCellAndBonuses) ?
            gameModel.getBgCells(compare: self.dontHaveGameCellAndBonuses) :
            gameModel.getBgCells(compare: self.dontContainGameCell)
        
        guard freeCells.count > 0 else {
            return
        }
        
        let random = Int.random(min: 0, max: freeCells.count - 1)
        if freeCells[random].bonus != nil {
            
            freeCells[random].removeBonusWithDisposeAnimation()
        }
        
        freeCells[random].block()
    }
    
}
