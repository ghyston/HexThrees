//
//  DropRandomBonusCMD.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 27.08.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class DropRandomBonusCMD : GameCMD {
    
    override func run() {
        
        //@todo: add random generator with probabilities etc
        
        //@todo: move selectors logic like this to HexField
        var freeCells = [BgCell]()
        for i in self.gameModel.bgHexes {
            if(i.gameCell == nil && i.isBlocked == false && i.bonus == nil) {
                freeCells.append(i)
            }
        }
        
        guard freeCells.count > 0 else {
            return
        }
        
        let random = Int(arc4random()) % freeCells.count
        
        if(Int(arc4random()) % 2 == 1) {
            
            let bonusNode = BonusFabric.createLockBonus(gameModel: self.gameModel)
            freeCells[random].addBonus(bonusNode)
        }
        else {
            
            let bonusNode = BonusFabric.createUnlockBonus(gameModel: self.gameModel)
            freeCells[random].addBonus(bonusNode)
        }
    }
}
