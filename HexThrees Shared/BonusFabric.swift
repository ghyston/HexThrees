//
//  BonusFabric.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 27.08.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

enum BonusType : Int, Codable {
    
    case UNLOCK_CELL
    case BLOCK_CELL
    case X2_POINTS
    case X3_POINTS
}

class BonusFabric {
    
    class func createBy(bonus type: BonusType, gameModel: GameModel) -> BonusNode {
        
        switch type {
        case .UNLOCK_CELL:
            return createUnlockBonus(gameModel: gameModel)
        case .BLOCK_CELL:
            return createLockBonus(gameModel: gameModel)
        case .X2_POINTS:
            return createX2Bonus(gameModel: gameModel)
        case .X3_POINTS:
            return createX3Bonus(gameModel: gameModel)
        }
    }
    
    class func createUnlockBonus(gameModel: GameModel) -> BonusNode {
        
        return BonusNode(
            type: .UNLOCK_CELL,
            spriteName: "bonus_unlock",
            turnsToDispose: GameConstants.BonusTurnsLifetime,
            onPick: UnlockRandomCellCMD(gameModel))
    }
    
    class func createLockBonus(gameModel: GameModel) -> BonusNode {
        
        return BonusNode(
            type: .BLOCK_CELL,
            spriteName: "bonus_lock",
            turnsToDispose: GameConstants.BonusTurnsLifetime,
            onPick: BlockRandomCellCMD(gameModel))
    }
    
    class func createX2Bonus(gameModel: GameModel) -> BonusNode {
        
        return BonusNode(
            type: .BLOCK_CELL,
            spriteName: "bonus_x2",
            turnsToDispose: GameConstants.BonusTurnsLifetime,
            onPick: AddScoreBaffCMD(gameModel, factor: 2))
    }
    
    class func createX3Bonus(gameModel: GameModel) -> BonusNode {
        
        return BonusNode(
            type: .BLOCK_CELL,
            spriteName: "bonus_x2",
            turnsToDispose: GameConstants.BonusTurnsLifetime,
            onPick: AddScoreBaffCMD(gameModel, factor: 3))
    }
    
}
