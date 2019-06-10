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
        
        guard gameModel.stressTimer.isEnabled() else {
            return
        }
        
        self.gameModel.stressTimer.startNew(timer:
        AddRandomCellCMD(self.gameModel)
            .runWithDelay(delay: GameConstants.StressTimerInterval))
        
        NotificationCenter.default.post(
            name: .startTimer,
            object: nil)
    }
}
