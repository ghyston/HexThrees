//
//  StuckCellCMD.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 07.10.19.
//  Copyright © 2019 Ilja Stepanow. All rights reserved.
//

import Foundation

protocol CollectableBonusCMD : GameCMD {
    var bonusType: BonusType { get }
}

//@todo: bad naming
class StuckCellCMD : RunOnNodeCMD, CollectableBonusCMD {
    
    var bonusType = BonusType.COLLECTABLE_TYPE_1
    
    override func run() {
        //@todo: implement
    }
}
