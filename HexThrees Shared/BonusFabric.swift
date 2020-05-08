//
//  BonusFabric.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 27.08.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

enum BonusType: Int, Codable {
	case UNLOCK_CELL
	case BLOCK_CELL
	case X2_POINTS
	case X3_POINTS
	case COLLECTABLE_UNLOCK_CELL
	case COLLECTABLE_PAUSE_TIMER
	case COLLECTABLE_SWIPE_BLOCK
	case COLLECTABLE_PICK_UP
	case EXPAND_FIELD
}

struct CollectableBonusModel {
	var currentValue: Int = 0
	let maxValue: Int
	mutating func inc() {
		currentValue = min(currentValue + 1, maxValue)
	}
	
	mutating func use() {
		currentValue = 0
	}
	
	var isFull: Bool {
		return currentValue >= maxValue
	}
}

class BonusFabric {
	class func collectableMaxValue(bonus type: BonusType) -> Int? {
		switch type {
		case .COLLECTABLE_UNLOCK_CELL:
			return 3
		case .COLLECTABLE_PAUSE_TIMER:
			return 3
		case .COLLECTABLE_SWIPE_BLOCK:
			return 3
		case .COLLECTABLE_PICK_UP:
			return 4
		default:
			return nil
		}
	}
	
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
		case .COLLECTABLE_SWIPE_BLOCK:
			return createCollectableSwipeBlockBonus(gameModel: gameModel)
		case .COLLECTABLE_PICK_UP:
			return createColletablePickUpBonus(gameModel: gameModel)
		case .EXPAND_FIELD:
			return createExpandFieldBonus(gameModel: gameModel)
		}
	}
	
	class func collectableSelectableBonusCMD(bonus type: BonusType, gameModel: GameModel) -> (comparator: (_: BgCell) -> Bool, cmd: RunOnNodeCMD)? {
		switch type {
		case .COLLECTABLE_UNLOCK_CELL:
			return (HexField.blockedCell, UnlockCellCMD(gameModel))
		case .COLLECTABLE_SWIPE_BLOCK:
			return (HexField.notBlockedCell, SwipeBlockCmd(gameModel))
		case .COLLECTABLE_PICK_UP:
			return (HexField.containGameCell, PickUpGameCellCmd(gameModel))
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
			return "bonus_x2"
		case .X3_POINTS:
			return "bonus_x2"
		case .COLLECTABLE_UNLOCK_CELL:
			return "bonus_unlock"
		case .COLLECTABLE_PAUSE_TIMER:
			return "cat_shit"
		case .COLLECTABLE_SWIPE_BLOCK:
			return "block_swipe"
		case .COLLECTABLE_PICK_UP:
			return "bonus_collectable"
		case .EXPAND_FIELD:
			return "expand_field"
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
	
	class func createCollectableSwipeBlockBonus(gameModel: GameModel) -> BonusNode {
		return BonusNode(
			type: .COLLECTABLE_SWIPE_BLOCK,
			spriteName: spriteName(bonus: .COLLECTABLE_SWIPE_BLOCK),
			turnsToDispose: GameConstants.BonusTurnsLifetime,
			onPick: CmdFactory().IncCollectableBonus(type: .COLLECTABLE_SWIPE_BLOCK))
	}
	
	class func createColletablePickUpBonus(gameModel: GameModel) -> BonusNode {
		BonusNode(
			type: .COLLECTABLE_PICK_UP,
			spriteName: spriteName(bonus: .COLLECTABLE_PICK_UP),
			turnsToDispose: GameConstants.BonusTurnsLifetime,
			onPick: CmdFactory().IncCollectableBonus(type: .COLLECTABLE_PICK_UP))
	}
	
	class func createExpandFieldBonus(gameModel: GameModel) -> BonusNode {
		BonusNode(
			type: .EXPAND_FIELD,
			spriteName: spriteName(bonus: .EXPAND_FIELD),
			turnsToDispose: GameConstants.BonusTurnsLifetime,
			onPick: TriggerFieldExpansionCmd(gameModel))
	}
}
