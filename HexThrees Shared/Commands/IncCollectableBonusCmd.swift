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
		
		guard let bonusType = type else {
			assert(true, "IncCollectableBonusCmd: bonus type was not set")
			return
		}
		
		if self.gameModel.collectableBonuses[bonusType] == nil {
			guard let maxValue = BonusFabric.collectableMaxValue(bonus: bonusType) else {
				assert(true, "IncCollectableBonusCmd: bonus type max value is incorrect")
				return
			}
			
			self.gameModel.collectableBonuses[bonusType] = CollectableBonusModel(
				currentValue: 0,
				maxValue: maxValue)
		}
		
        self.gameModel.collectableBonuses[bonusType]?.inc()
        NotificationCenter.default.post(name: .updateCollectables, object: type!)
    }
}
