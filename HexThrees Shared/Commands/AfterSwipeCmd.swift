//
//  AfterSwipeCMD.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 04.10.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class AfterSwipeCmd: GameCMD {
	override func run() {
		if !gameModel.swipeStatus.isSomethingChanged {
			return
		}
		
		UpdateBonusesCounterCMD(gameModel).run()
		UnlockSwypeBlockedCellsCmd(gameModel).run()
		
		if self.gameModel.tutorialManager.triggerForStep(
			model: gameModel,
			steps: .HighlightSecondCell, .EveryTurnDescription, .HighlightBonus, .KeepSwiping) {
			return
		}
		
		if gameModel.stressTimer.isEnabled() {
			gameModel.stressTimer.startDelay(
				timer:
					StartStressTimerCMD(gameModel)
						.runWithDelay(delay: GameConstants.StressTimerRollbackInterval))
		}
		
		CmdFactory().AddRandomCellSkipRepeat().run()
		DropRandomBonusCMD(gameModel).run()
		CheckGameEndCmd(gameModel).run()
		
		self.gameModel.field.executeForAll { $0.incLifetime() }
		
		gameModel.turnsWithoutSave += 1
		if gameModel.turnsWithoutSave > GameConstants.TurnsToAutoSave {
			SaveGameCMD(gameModel).run()
			gameModel.turnsWithoutSave = 0
		}
	}
}
