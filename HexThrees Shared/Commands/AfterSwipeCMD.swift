//
//  AfterSwipeCMD.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 04.10.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class AfterSwipeCMD : GameCMD {
    
    override func run() {
        if gameModel.swipeStatus.somethingChangeed {
            
            UpdateBonusesCounterCMD(gameModel).run()
            AddRandomCellCMD(gameModel).run()
            DropRandomBonusCMD(gameModel).run()
            CheckGameEndCMD(gameModel).run()
        }
        
        gameModel.shutDownHapticGenerator()
        gameModel.swipeStatus.delay = 0.0
        gameModel.swipeStatus.inProgress = false
    }
}
