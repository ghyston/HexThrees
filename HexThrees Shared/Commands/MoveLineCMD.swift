//
//  MoveLineCMD.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 23.05.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

// Try to move/merge cells in one dimension array from end to 0
class MoveLineCMD : GameCMD {
    
    private var count: Int = 0
    private var cells = Array<BgCell>()
    
    func run(cells: Array<BgCell>) {
        
        self.count = cells.count
        self.cells = cells
        
        //run recursive algorithm, starting with 0
        processCell(counter: 0)
    }
    
    private func processCell(counter: Int) {
        
        // end of algorithm : last cell achieved
        if counter >= count {
            return
        }
        
        // end of algorithm : no more cells with values
        guard let first : Int = findNextNonEmpty(startIndex: counter) else {
            return
        }
        
        // end of algorithm : one cells value, move it and collapse
        guard let second : Int = findNextNonEmpty(startIndex: first + 1) else {
            
            moveCell(from: first, to: counter)
            return
        }
        
        let firstVal = cells[first].gameCell!.value
        let secondVal = cells[second].gameCell!.value
        
        // If we have two cells in line with values, that can be collapsed
        if let newVal = gameModel.mergingStrategy.isSiblings(firstVal, secondVal) {
            
            let duration = moveCellAndDelete(from: second, to: counter) - GameConstants.SecondsPerCell
            
            //If first cellue with value in the beginning of index, we dont need to move it
            if first == counter {
                
                updateCell(index: counter, newVal: newVal, timeDelay: duration)
            }
            else {
                
                moveCell(from: first, to: counter)
                updateCell(index: counter, newVal: newVal, timeDelay: duration)
            }
            
            processCell(counter: counter + 1)
        }
        else {
            
            moveCell(from: first, to: counter)
            moveCell(from: second, to: counter + 1)
            processCell(counter: counter + 1)
        }
    }
    
    private func moveCell(from: Int, to: Int) {
        
        if from == to {
            return
        }
        
        checkMoveCellsAvailable(from, to)
        
        let fromCell = cells[from]
        let toCell = cells[to]
        
        SwitchParentsCMD(self.gameModel).run(from: fromCell, to: toCell)
        
        let diff = fromCell.destination(to: toCell)
        
        toCell.gameCell?.position.x -= diff.dx
        toCell.gameCell?.position.y -= diff.dy
        
        let duration = Double(from - to) * GameConstants.SecondsPerCell
        
        MoveCellSpriteCMD(self.gameModel).run(
            cell: toCell.gameCell!,
            diff: diff,
            duration: duration)
    }
    
    private func moveCellAndDelete(from: Int, to: Int) -> Double {
        
        if from == to {
            return 0.0
        }
        
        checkMoveCellsAvailable(from, to)
        
        let fromCell = cells[from]
        let toCell = cells[to]
        
        let diff = fromCell.destination(to: toCell)
        
        let gameCell = fromCell.gameCell!
        
        let duration = Double(from - to) * GameConstants.SecondsPerCell
        
        MoveCellSpriteCMD(self.gameModel).run(
            cell: gameCell,
            diff: diff,
            duration: duration)
        
        RemoveCellCMD(self.gameModel).run(cell: fromCell, delay: duration)
        
        return duration
    }
    
    private func updateCell(index: Int, newVal: Int, timeDelay: Double) {
        
        UpdateCellCMD(self.gameModel).run(
            cell: cells[index].gameCell!,
            value: newVal,
            delay: timeDelay)
    }
    
    private func findNextNonEmpty(startIndex: Int) -> Int? {
        
        for i in startIndex ..< count {
            if cells[i].gameCell != nil {
                return i
            }
        }
        
        return nil
    }
    
    private func checkMoveCellsAvailable(_ from: Int, _ to: Int) {
        
        assert(from < count, "MoveLineCMD: from >= count")
        assert(to < count, "MoveLineCMD: to >= count")
        assert(from > to, "MoveLineCMD: from >= to")
        assert(cells[from].gameCell != nil, "MoveLineCMD: \"from\" cell is empty")
    }
}
