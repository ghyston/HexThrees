//
//  AddRandomElementsCMD.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 30.10.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class AddRandomElementsCMD : GameCMD {
    
    func run(cells: Int, blocked: Int) {
        
        for _ in 0 ..< cells {
            
            AddRandomCellCMD(gameModel).runWithDelay(delay: Double.random)
        }
        
        for _ in 0 ..< blocked {
            
            BlockRandomCellCMD(gameModel).run()
        }
    }
}
