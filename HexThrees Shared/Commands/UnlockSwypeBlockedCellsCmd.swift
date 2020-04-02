//
//  UnlockSwypeBlockedCellsCmd.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 02.04.20.
//  Copyright © 2020 Ilja Stepanow. All rights reserved.
//

import Foundation

class UnlockSwypeBlockedCellsCmd : GameCMD {
    
    override func run() {
		let cells = self.gameModel.field.getBgCells(compare: HexField.userBlockedCell)
		for cell in cells {
			cell.unblockFromSwipe()
		}
    }
}
