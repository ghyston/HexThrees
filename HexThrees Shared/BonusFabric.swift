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
    case COLLECTABLE_UNLOCK_CELL
    case COLLECTABLE_PAUSE_TIMER
}

struct CollectableBonusModel {
    var currentValue : Int = 0
    let maxValue : Int
    mutating func inc() {
        currentValue = min(currentValue + 1, maxValue)
    }
    
    mutating func use() {
        currentValue = 0
    }
    
    var isFull: Bool {
        get {
            return currentValue >= maxValue
        }
    }
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
        case .COLLECTABLE_UNLOCK_CELL:
            return createCollectableUnlockCellBonus(gameModel: gameModel)
        case .COLLECTABLE_PAUSE_TIMER:
            return createCollectablePauseTimerBonus(gameModel: gameModel)
        }
    }
    
    class func collectableSelectableBonusCMD(bonus type: BonusType, gameModel: GameModel) -> (comparator: (_:BgCell)->Bool, cmd: RunOnNodeCMD)? {
        
        switch type {
        case .COLLECTABLE_UNLOCK_CELL:
            return (HexField.blockedCell, UnlockCellCMD(gameModel))
		default:
            return nil
        }
    }
	
	class func collectableNotSelectableBonusCMD(bonus type: BonusType, gameModel: GameModel) -> GameCMD? {
        
        switch type {
        case .COLLECTABLE_PAUSE_TIMER:
            return RollbackTimerCMD(gameModel)
        default:
            return nil
        }
    }
    
    class func spriteName(bonus type: BonusType) -> String {
        switch type {
        case .UNLOCK_CELL:
            return "bonus_unlock"
        case .BLOCK_CELL:
            return "bonus_lock"
        case .X2_POINTS:
            return  "bonus_x2"
        case .X3_POINTS:
            return  "bonus_x2"
        case .COLLECTABLE_UNLOCK_CELL:
            return  "bonus_unlock"
        case .COLLECTABLE_PAUSE_TIMER:
            return  "cat_shit"
        }
    }
    
    class func createUnlockBonus(gameModel: GameModel) -> BonusNode {
        
        return BonusNode(
            type: .UNLOCK_CELL,
            spriteName: spriteName(bonus: .UNLOCK_CELL),
            turnsToDispose: GameConstants.BonusTurnsLifetime,
            onPick: UnlockRandomCellCMD(gameModel))
    }
    
    class func createLockBonus(gameModel: GameModel) -> BonusNode {
        
        return BonusNode(
            type: .BLOCK_CELL,
            spriteName: spriteName(bonus: .BLOCK_CELL),
            turnsToDispose: GameConstants.BonusTurnsLifetime,
            onPick: BlockRandomCellCmd(gameModel))
    }
    
    class func createX2Bonus(gameModel: GameModel) -> BonusNode {
        
        return BonusNode(
            type: .X2_POINTS,
            spriteName: spriteName(bonus: .X2_POINTS),
            turnsToDispose: GameConstants.BonusTurnsLifetime,
            onPick: AddScoreBaffCMD(gameModel).setup(factor: 2))
    }
    
    class func createX3Bonus(gameModel: GameModel) -> BonusNode {
        
        return BonusNode(
            type: .X3_POINTS,
            spriteName: spriteName(bonus: .X3_POINTS),
            turnsToDispose: GameConstants.BonusTurnsLifetime,
            onPick: AddScoreBaffCMD(gameModel).setup(factor: 3))
    }
    
    class func createCollectableUnlockCellBonus(gameModel: GameModel) -> BonusNode {
        
        return BonusNode(
            type: .COLLECTABLE_UNLOCK_CELL,
            spriteName: spriteName(bonus: .COLLECTABLE_UNLOCK_CELL),
            turnsToDispose: GameConstants.BonusTurnsLifetime,
            onPick: CmdFactory().IncCollectableBonus(type: .COLLECTABLE_UNLOCK_CELL))
    }
    
    class func createCollectablePauseTimerBonus(gameModel: GameModel) -> BonusNode {
        
        return BonusNode(
            type: .COLLECTABLE_PAUSE_TIMER,
            spriteName: spriteName(bonus: .COLLECTABLE_PAUSE_TIMER),
            turnsToDispose: GameConstants.BonusTurnsLifetime,
            onPick: CmdFactory().IncCollectableBonus(type: .COLLECTABLE_PAUSE_TIMER))
    }
    
}
