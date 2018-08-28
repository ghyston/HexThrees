//
//  BonusFabric.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 27.08.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class BonusFabric {
    
    class func createUnlockBonus(gameModel: GameModel) -> BonusNode {
        
        return BonusNode(spriteName: "bonus_unlock", command: UnlockRandomCellCMD(gameModel))
    }
    
    class func createLockBonus(gameModel: GameModel) -> BonusNode {
        
        return BonusNode(spriteName: "bonus_lock", command: BlockRandomCellCMD(gameModel))
    }
    
    /*class func createX2Bonus(gameModel: GameModel) -> BonusNode {
        
        return BonusNode(spriteName: "x2", command: UnlockRandomCellCMD(gameModel))
    }*/
    
}
