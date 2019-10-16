//
//  AddRandomElementsCMD.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 30.10.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class AddRandomElementsCmd : GameCMD {
    
    private var cells : Int = 0
    private var blocked : Int = 0
    
    func setup(_ cells: Int, _ blocked: Int) -> GameCMD {
        self.cells = cells
        self.blocked = blocked
        return self
    }
    
    func run(cells: Int, blocked: Int) {
        for _ in 0 ..< cells {
            AddRandomCellCmd(gameModel)
                .skipRepeat()
                .runWithDelay(delay: Double.random)
        }
        
        for _ in 0 ..< blocked {
            BlockRandomCellCmd(gameModel).run()
        }
    }
}
