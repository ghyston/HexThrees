//
//  LineCellsContainer.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 19.06.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

//@todo: remove old implementation, when new will be ready
class LineCellsContainer {
    
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
        
        MoveLineCMD(self.gameModel).run(cells: cells)
        self.cells.removeAll(keepingCapacity: true)
    }
    
}

class LineCellsContainer2<FlushCommand : GameCMD> {
    
    var cells = [BgCell]()
    let gameModel : GameModel
    
    required init(_ gameModel: GameModel) {
        
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
    
    func clear() {
        
        //@todo: what will happen, when we clearing array of LineCellsContainer?
        self.flush()
    }
    
    //@todo: make this function private when all move commands would be refactored!
    func flush() {
        
        //FlushCommand(self.gameModel).run()
        
        MoveLineCMD(self.gameModel).run(cells: cells)
        
        self.cells.removeAll()
    }
    
}
