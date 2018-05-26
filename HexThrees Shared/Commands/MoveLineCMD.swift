//
//  MoveLineCMD.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 23.05.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

class MoveLineCMD : GameCMD {
    
    func run(cells: Array<BgCell>) {
        
        let count = cells.count
        
        func switchCellParent(from: BgCell, to: BgCell) {
            //@todo: after this do we need BGCell functions remove/add?
            from.gameCell?.removeFromParent()
            to.addGameCell(cell: from.gameCell!)
            from.gameCell = nil
        }
        
        func checkMoveCellsAvailable(_ from: Int, _ to: Int) {
            //@todo: throw if from >= count
            //@todo: throw if to >= count
            //@todo: throw if from >= to
            //@todo: throw if _from_ cell have gamecell (what if merging?)
            //@todo: throw if _to_ cell doesnt have gamecell
            
        }
        
        func moveCellAndDelete(from: Int, to: Int) -> Double {
            
            if from == to {
                return 0.0
            }
            
            checkMoveCellsAvailable(from, to)
            
            let fromCell = cells[from]
            let toCell = cells[to]
            
            //@todo: Add BGCell.distantion(to: BGCell)
            //@todo: add extensions to CGVector.init(points diff)
            let diff = CGVector(
                dx: toCell.position.x - fromCell.position.x,
                dy: toCell.position.y - fromCell.position.y)
            
            let secondsPerCell = 0.2 //@todo: move ot config?
            let duration = Double(from - to) * secondsPerCell
            
            let gameCell = fromCell.gameCell!
            
            fromCell.gameCell = nil
            
            gameCell.zPosition = 2 //@todo: define them as constants
            gameCell.playMoveAnimation(
                diff: diff,
                duration: duration)
            
            gameCell.removeFromParentCell(delay: duration)
            
            return duration
        }
        
        func moveCell(from: Int, to: Int) {
            
            if from == to {
                return
            }
            
            checkMoveCellsAvailable(from, to)
            
            let fromCell = cells[from]
            let toCell = cells[to]
            
            switchCellParent(from: fromCell, to: toCell)
            
            //@todo: add extensions to CGVector.init(points diff)
            let diff = CGVector(
                dx: toCell.position.x - fromCell.position.x,
                dy: toCell.position.y - fromCell.position.y)
            
            toCell.gameCell?.position.x -= diff.dx
            toCell.gameCell?.position.y -= diff.dy
            
            let secondsPerCell = 0.2
            let duration = Double(from - to) * secondsPerCell
            
            toCell.gameCell?.playMoveAnimation(
                diff: diff,
                duration: duration)
        }
        
        /*func deleteCell(index: Int) {
            cells[index].removeGameCell()
        }*/
        
        func updateCell(index: Int, newVal: Int, timeDelay: Double) {
            
            cells[index].gameCell?.updateValue(newVal, delay: timeDelay)
        }
        
        func findNextNonEmpty(startIndex: Int) -> Int? {
            
            var i = startIndex
            
            while i < count {
                if cells[i].gameCell != nil {
                    return i
                }
                i += 1
            }
            
            return nil
        }
        
        func processCell(counter: Int) {
            
            // end of algorithm
            if counter >= count {
                return
            }
            
            guard let first : Int = findNextNonEmpty(startIndex: counter) else {
                return
            }
            
            guard let second : Int = findNextNonEmpty(startIndex: first + 1) else {
                moveCell(from: first, to: counter)
                return
            }
            
            let firstVal = cells[first].gameCell!.value
            let secondVal = cells[second].gameCell!.value
            
            if let newVal = gameModel.mergingStrategy.isSiblings(firstVal, secondVal) {
                
                if first == counter {
                    
                    let duration = moveCellAndDelete(from: second, to: counter)
                    updateCell(index: counter, newVal: newVal, timeDelay: duration - 0.2)
                }
                else {
                    
                    let duration = moveCellAndDelete(from: second, to: counter)
                    moveCell(from: first, to: counter)
                    updateCell(index: counter, newVal: newVal, timeDelay: duration - 0.2)
                    
                }
                
                
                
                processCell(counter: counter + 1)
            }
            else {
                moveCell(from: first, to: counter)
                moveCell(from: second, to: counter + 1)
                processCell(counter: counter + 1)
            }
        }
        
        //run recursive algorithm, starting with 0
        processCell(counter: 0)
    }
}
