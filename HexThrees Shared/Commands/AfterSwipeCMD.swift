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
        if !gameModel.swipeStatus.somethingChangeed {
            return
        }
        
        UpdateBonusesCounterCMD(gameModel).run()
        
        //@todo: startTimer only if there are available cells
        if gameModel.stressTimerEnabled {
            
            RollbackTimerCMD(gameModel).run()
            StartStressTimerCMD(gameModel).runWithDelay(delay: GameConstants.StressTimerRollbackInterval)
        }
        AddRandomCellCMD(gameModel).skipRepeat().run()
        DropRandomBonusCMD(gameModel).run()
        CheckGameEndCMD(gameModel).run()
    }
}
