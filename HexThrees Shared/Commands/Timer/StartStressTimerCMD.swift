//
//  StartTimerCMD.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 09.05.19.
//  Copyright © 2019 Ilja Stepanow. All rights reserved.
//

import Foundation

class StartStressTimerCMD: GameCMD {
	override func run() {
		gameModel.stressTimer.cancelDelayedStart()
		
		guard gameModel.stressTimer.isEnabled() else {
			return
		}
		
		let cells = self.gameModel.field.getBgCellsWithPriority(
			required: HexField.freeCell,
			priority: HexField.cellWoBonuses, HexField.cellWoShader, HexField.oldCell)
		
		guard let bgCell = cells.randomElement() else {
			return
		}
		
		bgCell.playCircleAnimation()
		
		self.gameModel.stressTimer.startNew(
			timer: AddCellByTimerCMD(self.gameModel)
				.runWithDelay(delay: GameConstants.StressTimerInterval),
			cell: bgCell)
	}
}
