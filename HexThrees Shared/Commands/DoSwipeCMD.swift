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
        
        ApplyScoreBuffCMD(self.gameModel).run()
        
        if let iterator = self.chooseIterator(direction) {
            while let container = iterator.next() {
                MoveLineCMD(self.gameModel, cells: container).run()
            }
        }
        else {
            self.gameModel.swipeStatus.inProgress = false
        }
        
        if gameModel.swipeStatus.somethingChangeed {
            
            CheckGameEnd(gameModel).run() //@todo: unclear, where to show end screen?
            
            UpdateBonusesCounterCMD(gameModel).run()
            AddRandomCellCMD(gameModel).run()
            DropRandomBonusCMD(gameModel).run()
        }
        
        gameModel.swipeStatus.delay = 0.0
        gameModel.swipeStatus.inProgress = false
        
    }
    
    private func chooseIterator(_ direction : SwipeDirection) -> CellsIterator? {
        
        switch direction {
        case .Left:
            return MoveLeftIterator(self.gameModel)
        case .Right:
            return MoveRightIterator(self.gameModel)
        //case .XUp:
        //MoveXUpCMD(self.gameModel).run()
        case .YUp:
            return MoveYUpIterator(self.gameModel)
        //case .XDown:
        //MoveXDownCMD(self.gameModel).run()
        case .YDown:
            return MoveYDownIterator(self.gameModel)
        case .Unknown:
            fallthrough
        default:
            return nil
        }
        
    }
}
