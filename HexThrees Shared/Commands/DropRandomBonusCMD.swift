//
//  DropRandomBonusCMD.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 27.08.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class DropRandomBonusCMD: GameCMD {
	
	private static let startFieldEmptySocketCount =
		GameConstants.MaxFieldSize * GameConstants.MaxFieldSize -
		GameConstants.StartFieldSize * GameConstants.StartFieldSize
	
	override func run() {
		guard let randomFreeCell = self.gameModel.field.getBgCells(compare: HexField.freeCellWoBonuses).randomElement() else {
			return
		}
		
		let dropBonusProbability =
			Float(GameConstants.BaseBonusDropProbability) *
			Float(gameModel.turnsWithoutBonus)
		
		if Float.random > dropBonusProbability {
			gameModel.turnsWithoutBonus += 1
			return
		}
		
		gameModel.turnsWithoutBonus = 0
		
		let maxBonusesOnField = GameConstants.MaxBonusesOnScreen
		
		let bonusesOnField = self.gameModel.field.countBgCells(compare: { $0.bonus != nil })
		if bonusesOnField > maxBonusesOnField {
			return
		}
		
		let bonusTypes = ProbabilityArray<BonusType>()
		bonusTypes.add(.X2_POINTS, GameConstants.X2BonusProbability)
		bonusTypes.add(.X3_POINTS, GameConstants.X3BonusProbability)
		
		let emptySocketsCount = gameModel.field.countSockets(compare: HexField.isNotSet)
		let socketsOpened = Float(Self.startFieldEmptySocketCount - emptySocketsCount) // Documentation said, it should be Int but compiler disagreed 🙄
		let expandFieldProbability = GameConstants.ExpandFieldOriginalProbability * pow(1.0 - GameConstants.ExpandFieldDropProbability, socketsOpened)
		if emptySocketsCount > 0 {
			bonusTypes.add(.EXPAND_FIELD, expandFieldProbability)
		}
		
		let blockedCellsCount = self.gameModel.field.countBgCells(compare: { $0.isBlocked })
		if blockedCellsCount > 1 {
			bonusTypes.add(.UNLOCK_CELL, GameConstants.UnlockBonusProbability)
		}
		else if blockedCellsCount == 1 {
			bonusTypes.add(.UNLOCK_CELL, GameConstants.LastBlockedUnlockBonusProbability)
		}
		
		if self.gameModel.field.countBgCells(compare: HexField.freeCell) > 2 {
			bonusTypes.add(.BLOCK_CELL, GameConstants.LockBonusProbability)
		}
		
		for collectable in self.gameModel.collectableBonuses {
			if !collectable.value.isFull {
				bonusTypes.add(collectable.key, 1.0) // @todo: choose probability by type
			}
		}
		
		if self.gameModel.collectableBonuses.count < GameConstants.MaxBonusesOnPanel {
			if self.gameModel.collectableBonuses[.COLLECTABLE_UNLOCK_CELL] == nil,
				blockedCellsCount > 1 {
				bonusTypes.add(.COLLECTABLE_UNLOCK_CELL, GameConstants.CollectableUnlockCellBonusProbability)
			}
			
			if self.gameModel.collectableBonuses[.COLLECTABLE_SWIPE_BLOCK] == nil {
				bonusTypes.add(.COLLECTABLE_SWIPE_BLOCK, GameConstants.CollectableSwipeBlockBonusProbability)
			}
			
			if self.gameModel.collectableBonuses[.COLLECTABLE_PAUSE_TIMER] == nil,
				self.gameModel.stressTimer.isEnabled() {
				bonusTypes.add(.COLLECTABLE_PAUSE_TIMER, GameConstants.CollectablePauseTimerBonusProbability)
			}
			
			if self.gameModel.collectableBonuses[.COLLECTABLE_PICK_UP] == nil {
				bonusTypes.add(.COLLECTABLE_PICK_UP, GameConstants.CollectablePickUpBonusProbability)
			}
		}
		
		guard let bonusType = bonusTypes.getRandom() else {
			return
		}
		
		let bonusNode = BonusFabric.createBy(bonus: bonusType, gameModel: gameModel)
		randomFreeCell.addBonus(bonusNode)
	}
}
