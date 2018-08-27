//
//  MarkRandomCellAsBlockedCMD.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 20.06.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class BlockRandomCellCMD : GameCMD {
    
    override func run() {
        
        var freeCells = [BgCellNode]()
        for i in self.gameModel.bgHexes {
            if(i.gameCell == nil && !i.isBlocked) {
                freeCells.append(i)
            }
        }
        
        guard freeCells.count > 0 else {
            return
        }
        
        //@todo: wwdc game sessions about random!
        let random = Int(arc4random()) % freeCells.count
        
        freeCells[random].block()
    }
    
}
