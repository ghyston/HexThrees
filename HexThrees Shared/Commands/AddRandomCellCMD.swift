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
        
        var freeCells = Array<BgCellNode>()
        for i in self.gameModel.bgHexes {
            if(i.gameCell == nil && i.isBlocked == false) {
                freeCells.append(i)
            }
        }
        
        guard freeCells.count > 0 else {
            return
        }
        
        //@todo: wwdc game sessions about random!
        let random = Int(arc4random()) % freeCells.count
        
        let entity = EntityFabric.createPlCell(coordinates: <#T##CGPoint#>)
        
        let newElement = PlCellNode(
            model: self.gameModel,
            val: 0)
        freeCells[random].addGameCell(cell: newElement)
        newElement.playAppearAnimation()
    }
}
