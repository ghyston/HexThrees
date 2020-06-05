//
//  TutorialShowTimerCmd.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 01.06.20.
//  Copyright © 2020 Ilja Stepanow. All rights reserved.
//

import Foundation

class TutorialShowTimerCmd : GameCMD {
	override func run() {
		guard let bgCell = gameModel.field[3,2] else {
			return
		}
		
		let slowerThanUsual = 1.5
		bgCell.playCircleAnimation(durationMultiplier: slowerThanUsual)
		
		self.gameModel.stressTimer.startNew(
			timer: AddGameCellCmd(self.gameModel)
				.setup(addTo: bgCell, isTutorial: false, value: 0)
				.runWithDelay(delay: GameConstants.StressTimerInterval * slowerThanUsual),
			cell: bgCell)
		
		NotificationCenter.default.post(name: .updateSceneDescription, object: "keep swiping ↙️↘️\nto stop timer")
		
		let highlightDto = GameScene.HighlightCircleDto(
			coord: bgCell.position,
			rad: CGFloat(self.gameModel.geometry?.cellHeight ?? 50.0),
			delay: 0.0,
			name: TutorialNodeNames.TimerCell)
		NotificationCenter.default.post(name: .addSceneHighlight, object: [highlightDto])
		
		gameModel.swipeStatus.restrictDirections(to: .XDown, .YDown)
	}
}
