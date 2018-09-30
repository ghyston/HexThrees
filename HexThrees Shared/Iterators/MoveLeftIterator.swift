//
//  MoveLeftIterator.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 30.09.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class MoveLeftIterator : CellsIterator {
    
    let gameModel : GameModel
    
    private var line = LineCellsContainer2()
    
    private var y: Int = 0
    private var x: Int = 0
    private var w: Int { return self.gameModel.fieldWidth }
    private var h: Int { return self.gameModel.fieldHeight }
    
    private var d: Int = 0; // diagonal counter
    
    init(gameModel: GameModel) {
        
        self.gameModel = gameModel
    }
    
    private func getCell(_ x: Int, _ y: Int) -> BgCell {
        
        let index = y * w + x
        return self.gameModel.bgHexes[index]
    }
    
    func next() -> LineCellsContainer2? {
        
        line.flush()
        
        // Move along X from bottom to middle
        for _ in x ..< w {
            
            let len = x >= h ? h : x + 1
            
            for _ in (d ..< len) {
                
                let cell = getCell(x - d, d)
                d += 1
                
                if(cell.isBlocked) {
                    return line
                }
                else {
                    line.add(cell)
                }
            }
            x += 1
            d = 0
            
            return line
        }
        
        // Continue moving along Y from middle to top
        for _ in (y + 1)..<h {
            
            let len = y > (h - w) ? h - y : w
            
            for _ in (d ..< len) {
                
                let cell = getCell(w - d - 1, y + d)
                d += 1
                
                if(cell.isBlocked) {
                    return line
                }
                else {
                    line.add(cell)
                }
            }
            y += 1
            d = 0
            
            return line
        }
        
        return nil
    }

}
