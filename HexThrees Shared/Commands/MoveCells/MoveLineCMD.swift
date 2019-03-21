//
//  MoveLineCMD.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 23.05.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

//@todo: a god, you need to write some tests to this algorithm
// Try to move/merge cells in one dimension array from end to 0
class MoveLineCMD : GameCMD {
    
    private var cells : LineCellsContainer
    
    init(_ gameModel: GameModel, cells: LineCellsContainer) {
        
        self.cells = cells
        super.init(gameModel)
    }
    
    override func run() {
        
        //run recursive algorithm, starting with 0
        processCell(counter: 0)
    }
    
    private func processCell(counter: Int) {
        
        // end of algorithm : last cell achieved
        if counter >= cells.count {
            return
        }
        
        func notEmpty (cell: BgCell) -> Bool {
            
            return cell.gameCell != nil
        }
        
        // end of algorithm : no more cells with values
        guard let first = cells.findNext(
            startIndex: counter,
            condition: notEmpty) else {
            return
        }
        
        // end of algorithm : one cells value, move it and collapse
        guard let second = cells.findNext(
            startIndex: first.index + 1,
            condition: notEmpty) else {
            
            moveCell(from: first.index, to: counter)
            return
        }
        
        let firstVal = first.cell.gameCell!.value
        let secondVal = second.cell.gameCell!.value
        
        // If we have two cells in line with values, that can be collapsed
        if let newVal = gameModel.strategy.isSiblings(firstVal, secondVal) {
            
            let duration = moveCellAndDelete(
                from: second.index,
                to: counter)
                - GameConstants.SecondsPerCell
            
            //If first cellue with value in the beginning of index, we dont need to move it
            if first.index == counter {
                
                updateCell(index: counter, newVal: newVal, timeDelay: duration)
            }
            else {
                
                moveCell(from: first.index, to: counter)
                updateCell(index: counter, newVal: newVal, timeDelay: duration)
            }
            
            processCell(counter: counter + 1)
        }
        else {
            
            moveCell(from: first.index, to: counter)
            moveCell(from: second.index, to: counter + 1)
            processCell(counter: counter + 1)
        }
    }
    
    private func moveCell(from: Int, to: Int) {
        
        if from == to {
            return
        }
        
        self.gameModel.swipeStatus.somethingChangeed = true
        
        cells.cellsAvailableForMove(from, to)
        
        pickUpBonuses(from, to)
        
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
        runSelectHaptic(times: from - to)
    }
    
    private func runSelectHaptic(times: Int) {
        for i in 0 ..< times {
            SelectHapticFeedbackCMD(self.gameModel).runWithDelay(delay : Double(1 + i) * GameConstants.SecondsPerCell)
        }
    }
    
    private func moveCellAndDelete(from: Int, to: Int) -> Double {
        
        if from == to {
            return 0.0
        }
        
        self.gameModel.swipeStatus.somethingChangeed = true
        
        cells.cellsAvailableForMove(from, to)
        
        pickUpBonuses(from, to)
        
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
        runSelectHaptic(times: from - to - 1)
        ImpactHapticFeedbackCMD(self.gameModel).runWithDelay(delay : duration)
        
        return duration
    }
    
    private func updateCell(index: Int, newVal: Int, timeDelay: Double) {
        
        UpdateCellCMD(self.gameModel)
            .setup(
                cell: cells[index].gameCell!,
                value: newVal)
            .runWithDelay(delay: timeDelay)
        let deltaScore = gameModel.strategy.value(index: newVal - 1) * self.gameModel.scoreMultiplier
        UpdateScoreCMD(self.gameModel).run(deltaScore)
    }
    
    private func pickUpBonuses(_ from: Int, _ to: Int) {
        
        for i in to...from {
            if let bonus = cells[i].bonus {
                
                let delay = Double(from - i) * GameConstants.SecondsPerCell
                bonus.command.runWithDelay(delay: delay)
                cells[i].removeBonusWithPickingAnimation(delay)
            }
        }
    }
}
