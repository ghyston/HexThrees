//
//  DoSwipeCMD.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 13.06.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class DoSwipeCMD : GameCMD {
    
    func run(direction : SwipeDirection) {
        
        if self.gameModel.swipeStatus.inProgress {
            return
        }
        
        self.gameModel.swipeStatus.inProgress = true
        self.gameModel.swipeStatus.somethingChangeed = false
        
        switch direction {
        case .Left:
            MoveLeftCMD(self.gameModel).run()
        case .Right:
            MoveRightCMD(self.gameModel).run()
        case .XUp:
            MoveXUpCMD(self.gameModel).run()
        case .YUp:
            MoveYUpCMD(self.gameModel).run()
        case .XDown:
            MoveXDownCMD(self.gameModel).run()
        case .YDown:
            MoveYDownCMD(self.gameModel).run()
        case .Unknown:
            self.gameModel.swipeStatus.inProgress = false
            return
        }
        
        if gameModel.swipeStatus.somethingChangeed {
            
            UpdateBonusesCounterCMD(gameModel).run()
            AddRandomCellCMD(gameModel).run()
            DropRandomBonusCMD(gameModel).run()
        }
        
        gameModel.swipeStatus.delay = 0.0
        gameModel.swipeStatus.inProgress = false
        
    }
}
