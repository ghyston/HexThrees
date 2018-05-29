//
//  AddRandomCellCMD.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 23.05.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class AddRandomCellCMD : GameCMD {
    
    override func run() {
        
        var freeCells = Array<BgCell>()
        for i in self.gameModel.bgHexes {
            if(i.gameCell == nil) {
                freeCells.append(i)
            }
        }
        
        guard freeCells.count > 0 else {
            return
        }
        
        let random = Int(arc4random()) % freeCells.count
        
        let newElement = GameCell(val: 1)
        freeCells[random].addGameCell(cell: newElement)
        newElement.playAppearAnimation()
    }
}
