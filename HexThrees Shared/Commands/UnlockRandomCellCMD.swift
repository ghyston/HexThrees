//
//  UnlockRandomCellCMD.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 20.06.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class UnlockRandomCellCMD : GameCMD {
    
    override func run() {
        self.gameModel.field
            .getBgCells(compare: { $0.isBlocked } )
            .randomElement()?.unblock()
    }
    
}
