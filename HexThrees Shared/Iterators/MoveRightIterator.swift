//
//  MoveRightIterator.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 30.09.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class MoveRightIterator : BaseCellsIterator, CellsIterator {
    
    private var d: Int = 0; // diagonal counter
    
    func next() -> LineCellsContainer? {
        
        line.clear()
        
        // Move along X from bottom to middle
        for _ in x ..< w - 1 {
            
            let len = x >= h ? h : x + 1
            
            for _ in (d ..< len) {
                
                let cell = getCell(x - d, d)
                d += 1
                
                if(cell.isBlocked || cell.isBlockedFromSwipe) {
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
                
                if(cell.isBlocked || cell.isBlockedFromSwipe) {
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
