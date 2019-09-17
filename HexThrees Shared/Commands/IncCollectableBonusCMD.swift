//
//  IncCollectableBonusCounterCMD.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 16.09.19.
//  Copyright © 2019 Ilja Stepanow. All rights reserved.
//

import Foundation

class IncCollectableBonusCMD : GameCMD {
    
    let type: BonusType
    
    init(_ gameModel: GameModel, type: BonusType) {
        self.type = type
        super.init(gameModel)
    }
    
    override func run() {
        self.gameModel.collectableBonuses[type]?.inc()
        NotificationCenter.default.post(name: .updateCollectables, object: type)
    }
}
