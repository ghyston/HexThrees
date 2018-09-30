//
//  LineCellsContainer.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 19.06.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class LineCellsContainer {
    
    var cells = [BgCell]()
    
    var count : Int {
        
        return cells.count
    }
    
    func add(_ cell: BgCell) {
        self.cells.append(cell)
    }
    
    subscript (index: Int) -> BgCell {
        
        return cells[index];
    }
    
    func findNext(startIndex: Int, condition: (BgCell) -> Bool) -> (index: Int, cell: BgCell)? {
        
        for (index, cell) in cells[startIndex...].enumerated() {
            if condition(cell) {
                return (startIndex + index, cell)
            }
        }
        
        return nil
    }
    
    func cellsAvailableForMove(_ from: Int, _ to: Int) {
        
        assert(from < count, "MoveLineCMD: from >= count")
        assert(to < count, "MoveLineCMD: to >= count")
        assert(from > to, "MoveLineCMD: from >= to")
        assert(cells[from].gameCell != nil, "MoveLineCMD: \"from\" cell is empty")
    }

    
    
    func clear() {
        
        self.cells.removeAll(keepingCapacity: true)
    }
}
