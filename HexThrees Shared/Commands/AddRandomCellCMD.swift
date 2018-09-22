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
        
        guard let bgCell = self.gameModel.getBgCells(compare: self.isCellFree).randomElement() else {
            return
        }
        
        let newElement = GameCell(
            model: self.gameModel,
            val: 0)
        bgCell.addGameCell(cell: newElement)
        newElement.playAppearAnimation()
        
        bgCell.bonus?.command.run()
        bgCell.removeBonusWithPickingAnimation(0.0)
    }
}
