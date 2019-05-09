//
//  StartTimerCMD.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 09.05.19.
//  Copyright © 2019 Ilja Stepanow. All rights reserved.
//

import Foundation

class StartStressTimerCMD : GameCMD {
    
    override func run() {
        
        guard gameModel.stressTimerEnabled else {
            return
        }
        
        self.gameModel.stressTimer?.invalidate()
        self.gameModel.stressTimer =
        AddRandomCellCMD(self.gameModel).runWithDelay(delay: GameConstants.StressTimerInterval)
    }
}
