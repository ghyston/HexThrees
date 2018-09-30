//
//  MoveLeftIterator.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 26.09.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation



class MoveYDownIterator: CellsIterator {
    
    let gameModel : GameModel
    
    private var line = LineCellsContainer2()
    
    private var y: Int = 0
    private var x: Int = 0
    private var w: Int { return self.gameModel.fieldWidth }
    private var h: Int { return self.gameModel.fieldHeight }
    
    init(gameModel: GameModel) {
        
        self.gameModel = gameModel
    }
    
    private func getCell(_ x: Int, _ y: Int) -> BgCell {
        let index = y * self.gameModel.fieldWidth + x
        return self.gameModel.bgHexes[index]
    }
   
    func next() -> LineCellsContainer2? {
        
        line.flush()
 
        if y >= h {
            y = 0
            x += 1
        }
        
        if x >= w {
            return nil;
        }
        
        for _ in y ..< h {
            
            let cell = getCell(x, y)
            
            y += 1
            
            if(cell.isBlocked) {
                break
            }
            
            line.add(cell)
        }
        
        return line;
    }
    
}
