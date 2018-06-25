//
//  MoveLeftCMD.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 24.05.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class MoveRightCMD : GameCMD {
    
    override func run() {
        
        let w = self.gameModel.fieldWidth
        let h = self.gameModel.fieldHeight
        let line = LineCellsContainer(self.gameModel)
        
        for i in 0 ..< w {
            
            let len = i >= h ? h : i + 1
            
            if len < 2 {
                continue
            }
            
            for j in 0 ..< len {
                let x = i - j
                let y = j
                
                line.add(y * w + x)
            }
            line.flush()
        }
        
        for i in 1..<h {
            
            let len = i > (h - w) ? h - i : w
            
            if len < 2 {
                continue
            }
            
            for j in 0 ..< len {
                
                let x = w - j - 1
                let y = i + j
                
                line.add(y * w + x)
            }
            
            line.flush()
        }
        
    }
}
