//
//  CheckGameEnd.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 04.07.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class CheckGameEndCMD : GameCMD {
    
    override func run() {
        
        //First, check is there any free space
        if gameModel.field.hasBgCells(compare: HexField.freeCell) {
            return
        }
        
        // Check possible movement on all directions
        let iterators = [
            MoveLeftIterator(self.gameModel),
            MoveRightIterator(self.gameModel),
            MoveXUpIterator(self.gameModel),
            MoveYUpIterator(self.gameModel),
            MoveXDownIterator(self.gameModel),
            MoveYDownIterator(self.gameModel)]
        
        for iterator in iterators {
            while let line = (iterator as! CellsIterator).next() {
                if(line.check(strategy: gameModel.strategy)) {
                    return
                }
            }
        }
        
        //thisIsTheEnd = true //my only friend
        NotificationCenter.default.post(name: .gameOver, object: nil)
    }
}
