//
//  ApplyMultiplierToScoreCMD.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 31.08.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class AddScoreBaffCMD: GameCMD {
    
    let factor: Int
    
    init(_ gameModel: GameModel, factor: Int) {
        
        self.factor = factor
        super.init(gameModel)
    }
    
    override func run() {
        
        self.gameModel.scoreBuffs.append(
            ScoreBuff(
                turnsToApply: 3,
                factor: self.factor))
    }
}
