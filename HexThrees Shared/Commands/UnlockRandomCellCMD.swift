//
//  UnlockRandomCellCMD.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 20.06.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class UnlockRandomCellCMD : GameCMD {
    
    // @todo: is it possible to make it inline AND/OR lambda?
    private func isBlocked(cell: BgCell) -> Bool {
        return cell.isBlocked
    }
    
    override func run() {
        self.gameModel.field
            .getBgCells(compare: self.isBlocked)
            .randomElement()?.unblock()
    }
    
}
