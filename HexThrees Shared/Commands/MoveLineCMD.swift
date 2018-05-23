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
        
        func moveCell(from: Int, to: Int, newVal: Int?) {
            
            if from == to {
                return
            }
            
            //@todo: throw if from >= count
            //@todo: throw if to >= count
            //@todo: throw if from >= to
            //@todo: throw if _from_ cell have gamecell (what if merging?)
            //@todo: throw if _to_ cell doesnt have gamecell
            
            let fromCell = cells[from]
            let toCell = cells[to]
            
            switchCellParent(from: fromCell, to: toCell)
            
            //@todo: add extensions to CGVector.init(points diff)
            let diff = CGVector(
                dx: toCell.position.x - fromCell.position.x,
                dy: toCell.position.y - fromCell.position.y)
            
            toCell.gameCell?.position.x -= diff.dx
            toCell.gameCell?.position.y -= diff.dy
            
            let moveAction = SKAction.move(by: diff, duration: Double(from - to) * 0.2) //@todo: duration should depend from distance
            toCell.gameCell?.run(moveAction)
            
            if newVal != nil {
                //@todo: run some animation?
                toCell.gameCell?.updateValue(newVal!)
            }
        }
        
        func deleteCell(index: Int) {
            cells[index].removeGameCell()
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
                moveCell(from: first, to: counter, newVal: nil) //@todo: make newVal a optional parameter
                return
            }
            
            let firstVal = cells[first].gameCell!.value
            let secondVal = cells[second].gameCell!.value
            
            if let newVal = gameModel.mergingStrategy.isSiblings(firstVal, secondVal) {
                deleteCell(index: first)
                moveCell(from: second, to: counter, newVal: newVal)
                processCell(counter: counter + 1)
            }
            else {
                moveCell(from: first, to: counter, newVal: nil)
                moveCell(from: second, to: counter + 1, newVal: nil)
                processCell(counter: counter + 1)
            }
        }
        
        //run recursive algorithm, starting with 0
        processCell(counter: 0)
    }
}
