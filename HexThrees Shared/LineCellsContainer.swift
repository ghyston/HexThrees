//
//  LineCellsContainer.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 19.06.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class LineCellsContainer {
    
    var cells = [BgCellNode]()
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
        
        self.cells.removeAll()
    }
    
}
