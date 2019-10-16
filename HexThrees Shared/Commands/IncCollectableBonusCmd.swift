//
//  IncCollectableBonusCounterCMD.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 16.09.19.
//  Copyright © 2019 Ilja Stepanow. All rights reserved.
//

import Foundation

class IncCollectableBonusCmd : GameCMD {
    
    private var type: BonusType?
    
    func setup(_ type: BonusType) -> GameCMD {
        self.type = type
        return self
    }
    
    override func run() {
        self.gameModel.collectableBonuses[type!]?.inc()
        NotificationCenter.default.post(name: .updateCollectables, object: type!)
    }
}
