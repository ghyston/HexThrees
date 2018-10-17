//
//  CheckGameEnd.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 04.07.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class CheckGameEndCMD : GameCMD {
    
    private func dontContainGameCell (cell: BgCell) -> Bool {
        
        return
            cell.gameCell == nil &&
                !cell.isBlocked
    }
    
    private func notEmpty (cell: BgCell) -> Bool {
        
        return cell.gameCell != nil
    }
    
    override func run() {
        
        //First, check is there any free space
        if gameModel.hasBgCells(compare: self.dontContainGameCell) {
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
                if(check(line: line)) {
                    return
                }
            }
        }
        
        //thisIsTheEnd = true //my only friend
        NotificationCenter.default.post(name: .gameOver, object: nil)
    }
    
    //@return true if line can be moved
    func check(line: LineCellsContainer, from : Int = 0) -> Bool {
     
        guard let first = line.findNext(startIndex: from, condition: notEmpty) else {
            return false
        }
        
        // if it was last cell in line
        if first.index == line.count - 1 {
            return false
        }
        
        let nextCell = line[first.index + 1]
        
        // If next cell is empty, line can be moved
        if !self.notEmpty(cell: nextCell) {
            return true
        }
        else {
         
            // If first and next cell can be merged, we are fine
            if (gameModel.strategy.isSiblings(first.cell.gameCell!.value, nextCell.gameCell!.value) != nil) {
                return true
            }
            // If not may be next and next after next can be merged?
            else {
                return check(line: line, from: from + 1)
            }
        }
    }
    
}
