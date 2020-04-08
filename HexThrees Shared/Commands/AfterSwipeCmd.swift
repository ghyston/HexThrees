//
//  AfterSwipeCMD.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 04.10.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class AfterSwipeCmd : GameCMD {
    
    override func run() {
        if !gameModel.swipeStatus.isSomethingChanged {
            return
        }
        
        UpdateBonusesCounterCMD(gameModel).run()
		UnlockSwypeBlockedCellsCmd(gameModel).run()
        
        //@todo: startTimer only if there are available cells
        if gameModel.stressTimer.isEnabled() {
            _ = StartStressTimerCMD(gameModel).runWithDelay(delay: GameConstants.StressTimerRollbackInterval)
        }
        
        CmdFactory().AddRandomCellSkipRepeat().run()
        DropRandomBonusCMD(gameModel).run()
        CheckGameEndCmd(gameModel).run()
    }
}
