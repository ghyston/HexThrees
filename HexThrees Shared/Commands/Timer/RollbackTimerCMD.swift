//
//  RollbackTimerCMD.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 26.05.19.
//  Copyright © 2019 Ilja Stepanow. All rights reserved.
//

import Foundation

class RollbackTimerCMD : GameCMD {
    
    override func run() {
        
        guard gameModel.stressTimerEnabled else {
            return
        }
        
        self.gameModel.stressTimer?.invalidate()
        
        NotificationCenter.default.post(
            name: .rollbackTimer,
            object: nil)
    }
}
