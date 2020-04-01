//
//  StuckCellCMD.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 07.10.19.
//  Copyright © 2019 Ilja Stepanow. All rights reserved.
//

import Foundation

//@todo: do we need spearate protocol for this?
protocol CollectableBonusCMD : GameCMD {
    var bonusType: BonusType { get }
}

class UnlockCellCMD : RunOnNodeCMD, CollectableBonusCMD {
    
    var bonusType = BonusType.COLLECTABLE_UNLOCK_CELL
    
    override func run() {
		self.node?.unblock()
    }
}
