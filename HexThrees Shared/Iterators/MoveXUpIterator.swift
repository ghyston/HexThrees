//
//  MoveXUpIterator.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 30.09.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class MoveXUpIterator: BaseCellsIterator, CellsIterator {
    
    override init(_ gameModel: GameModel) {
        
        super.init(gameModel)
        x = w - 1
    }
    
    func next() -> LineCellsContainer2? {
        
        line.flush()
        
        if x < 0 {
            x = w - 1
            y += 1
        }
        
        if y >= h {
            return nil;
        }
        
        for _ in 0 ... x {
            
            let cell = getCell(x, y)
            
            x -= 1
            
            if(cell.isBlocked) {
                break
            }
            
            line.add(cell)
        }
        
        return line;
    }
    
}
