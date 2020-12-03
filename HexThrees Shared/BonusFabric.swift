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
	
	private static let factoryMethods = [
		BonusType.UNLOCK_CELL: 				createUnlockBonus,
		BonusType.BLOCK_CELL: 				createLockBonus,
		BonusType.X2_POINTS: 				createX2Bonus,
		BonusType.X3_POINTS: 				createX3Bonus,
		BonusType.COLLECTABLE_UNLOCK_CELL:	createCollectableUnlockCellBonus,
		BonusType.COLLECTABLE_PAUSE_TIMER:	createCollectablePauseTimerBonus,
		BonusType.COLLECTABLE_SWIPE_BLOCK:	createCollectableSwipeBlockBonus,
		BonusType.COLLECTABLE_PICK_UP: 		createColletablePickUpBonus,
		BonusType.EXPAND_FIELD: 			createExpandFieldBonus
	]
	
	private static let iconNames : [BonusType: String] = [
		.UNLOCK_CELL: 				"key",
		.BLOCK_CELL: 				"lock",
		.X2_POINTS: 				"doubleScore",
		.X3_POINTS: 				"tripleScore",
		.COLLECTABLE_UNLOCK_CELL:	"key",
		.COLLECTABLE_PAUSE_TIMER:	"pause",
		.COLLECTABLE_SWIPE_BLOCK:	"block",
		.COLLECTABLE_PICK_UP:		"pickup",
		.EXPAND_FIELD: 				"expand"
	]
	
	class func createBy(bonus type: BonusType, gameModel: GameModel) -> BonusNode {
		factoryMethods[type]!(gameModel).scale(hexRad: gameModel.geometry!.iconSize)
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
		iconNames[type]!
	}
	
	private class func createUnlockBonus(gameModel: GameModel) -> BonusNode {
		BonusNode(
			type: .UNLOCK_CELL,
			spriteName: spriteName(bonus: .UNLOCK_CELL),
			turnsToDispose: GameConstants.BonusTurnsLifetime,
			onPick: UnlockRandomCellCMD(gameModel))
	}
	
	private class func createLockBonus(gameModel: GameModel) -> BonusNode {
		BonusNode(
			type: .BLOCK_CELL,
			spriteName: spriteName(bonus: .BLOCK_CELL),
			turnsToDispose: GameConstants.BonusTurnsLifetime,
			onPick: BlockRandomCellCmd(gameModel))
	}
	
	private class func createX2Bonus(gameModel: GameModel) -> BonusNode {
		BonusNode(
			type: .X2_POINTS,
			spriteName: spriteName(bonus: .X2_POINTS),
			turnsToDispose: GameConstants.BonusTurnsLifetime,
			onPick: AddScoreBaffCMD(gameModel).setup(factor: 2))
	}
	
	private class func createX3Bonus(gameModel: GameModel) -> BonusNode {
		BonusNode(
			type: .X3_POINTS,
			spriteName: spriteName(bonus: .X3_POINTS),
			turnsToDispose: GameConstants.BonusTurnsLifetime,
			onPick: AddScoreBaffCMD(gameModel).setup(factor: 3))
	}
	
	private class func createCollectableUnlockCellBonus(gameModel: GameModel) -> BonusNode {
		BonusNode(
			type: .COLLECTABLE_UNLOCK_CELL,
			spriteName: spriteName(bonus: .COLLECTABLE_UNLOCK_CELL),
			turnsToDispose: GameConstants.BonusTurnsLifetime,
			onPick: CmdFactory().IncCollectableBonus(type: .COLLECTABLE_UNLOCK_CELL))
	}
	
	private class func createCollectablePauseTimerBonus(gameModel: GameModel) -> BonusNode {
		BonusNode(
			type: .COLLECTABLE_PAUSE_TIMER,
			spriteName: spriteName(bonus: .COLLECTABLE_PAUSE_TIMER),
			turnsToDispose: GameConstants.BonusTurnsLifetime,
			onPick: CmdFactory().IncCollectableBonus(type: .COLLECTABLE_PAUSE_TIMER))
	}
	
	private class func createCollectableSwipeBlockBonus(gameModel: GameModel) -> BonusNode {
		BonusNode(
			type: .COLLECTABLE_SWIPE_BLOCK,
			spriteName: spriteName(bonus: .COLLECTABLE_SWIPE_BLOCK),
			turnsToDispose: GameConstants.BonusTurnsLifetime,
			onPick: CmdFactory().IncCollectableBonus(type: .COLLECTABLE_SWIPE_BLOCK))
	}
	
	private class func createColletablePickUpBonus(gameModel: GameModel) -> BonusNode {
		BonusNode(
			type: .COLLECTABLE_PICK_UP,
			spriteName: spriteName(bonus: .COLLECTABLE_PICK_UP),
			turnsToDispose: GameConstants.BonusTurnsLifetime,
			onPick: CmdFactory().IncCollectableBonus(type: .COLLECTABLE_PICK_UP))
	}
	
	private class func createExpandFieldBonus(gameModel: GameModel) -> BonusNode {
		BonusNode(
			type: .EXPAND_FIELD,
			spriteName: spriteName(bonus: .EXPAND_FIELD),
			turnsToDispose: GameConstants.BonusTurnsLifetime,
			onPick: TriggerFieldExpansionCmd(gameModel))
	}
}
