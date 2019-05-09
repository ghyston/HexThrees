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
        
        let nextCellCMD : GameCMD = gameModel.stressTimerEnabled ? 
            StartStressTimerCMD(gameModel) :
            AddRandomCellCMD(gameModel)
        nextCellCMD.run()
        
        DropRandomBonusCMD(gameModel).run()
        CheckGameEndCMD(gameModel).run()
    }
}
