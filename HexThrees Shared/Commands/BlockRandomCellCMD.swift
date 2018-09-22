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
        
        let freeCells = gameModel.hasBgCells(compare: self.dontHaveGameCellAndBonuses) ?
            gameModel.getBgCells(compare: self.dontHaveGameCellAndBonuses) :
            gameModel.getBgCells(compare: self.dontContainGameCell)
        
        guard let randomCell = freeCells.randomElement() else {
            return
        }
        
        if randomCell.bonus != nil {
            
            randomCell.removeBonusWithDisposeAnimation()
        }
        
        randomCell.block()
    }
    
}
