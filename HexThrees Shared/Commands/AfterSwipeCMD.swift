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
        if !gameModel.swipeStatus.isSomethingChanged {
            return
        }
        
        UpdateBonusesCounterCMD(gameModel).run()
        
        //@todo: startTimer only if there are available cells
        if gameModel.stressTimer.isEnabled() {
            
            RollbackTimerCMD(gameModel).run()
            StartStressTimerCMD(gameModel).runWithDelay(delay: GameConstants.StressTimerRollbackInterval)
        }
        AddRandomCellCMD(gameModel).skipRepeat().run()
        DropRandomBonusCMD(gameModel).run()
        CheckGameEndCMD(gameModel).run()
    }
}
