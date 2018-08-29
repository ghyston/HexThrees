//
//  AddRandomCellCMD.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 23.05.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class AddRandomCellCMD : GameCMD {
    
    
    private func isCellFree(cell: BgCell) -> Bool {
        
        return cell.gameCell == nil &&
            cell.isBlocked == false
    }
    
    override func run() {
        
        var freeCells = self.gameModel.getBgCells(
            compare: self.isCellFree)
        
        guard freeCells.count > 0 else {
            return
        }
        
        let random = Int.random(min: 0, max: freeCells.count - 1)
        
        let newElement = GameCell(
            model: self.gameModel,
            val: 0)
        freeCells[random].addGameCell(cell: newElement)
        newElement.playAppearAnimation()
        
        freeCells[random].bonus?.command.run()
        freeCells[random].removeBonusWithPickingAnimation(0.0)
    }
}
