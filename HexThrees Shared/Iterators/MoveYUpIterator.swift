//
//  MoveYUpIterator.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 27.09.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class MoveYUpIterator: BaseCellsIterator, CellsIterator {
    
    func next() -> LineCellsContainer2? {
        
        line.flush()
        
        if y < 0 {
            y = h - 1
            x += 1
        }
        
        if x >= w {
            return nil;
        }
        
        for _ in 0 ... y {
            
            let cell = getCell(x, y)
            
            y -= 1
            
            if(cell.isBlocked) {
                break
            }
            
            line.add(cell)
        }
        
        return line;
    }
    
}
