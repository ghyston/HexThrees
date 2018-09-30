//
//  LineCellsContainer.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 19.06.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

//@todo: remove old implementation, when new will be ready
/*class LineCellsContainer {
    
    var cells = [BgCell]()
    let gameModel : GameModel
    
    init(_ gameModel: GameModel) {
        
        self.gameModel = gameModel
    }
    
    func add(_ index: Int) {
        
        let cell = self.gameModel.bgHexes[index]
        
        if cell.isBlocked {
            
            self.flush()
        }
        else {
            
            self.cells.append(cell)
        }
    }
    
    func flush() {
        
        MoveLineCMD(self.gameModel, cells).run()
        self.cells.removeAll(keepingCapacity: true)
    }
    
}*/


//@todo: implement can be merged ?

class LineCellsContainer2 {
    
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

    func canBeMoved() -> Bool {
        
        //@todo: implement this!
        return true
    }
    
    func clear() {
        
        //@todo: what will happen, when we clearing array of LineCellsContainer?
        self.flush()
    }
    
    //@todo: make this function private when all move commands would be refactored!
    func flush() {
        
        //FlushCommand(self.gameModel).run()
        
        //MoveLineCMD(self.gameModel, cells: self).run()
        
        self.cells.removeAll(keepingCapacity: true)
    }
    
    
    
}
