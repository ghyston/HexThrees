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
        
        //@todo: wwdc game sessions about random!
        let random = Int(arc4random()) % freeCells.count
        
        let newElement = GameCell(
            model: self.gameModel,
            val: 0)
        freeCells[random].addGameCell(cell: newElement)
        newElement.playAppearAnimation()
    }
}
