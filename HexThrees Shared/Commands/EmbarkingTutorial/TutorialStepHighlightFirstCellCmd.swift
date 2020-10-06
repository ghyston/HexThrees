//
//  TutorialStepHighlightFirstCellCmd.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 29.05.20.
//  Copyright © 2020 Ilja Stepanow. All rights reserved.
//

import Foundation

class TutorialStepHighlightFirstCellCmd: GameCMD {
	override func run() {
		guard let bgCell = self.gameModel.field[2, 4] else {
			assert(false, "TutorialStep1Cmd: BgCell with coordinates (2, 4) is not exist")
			return
		}
		AddGameCellCmd(self.gameModel).setup(addTo: bgCell, isTutorial: false, value: 0).run()
		self.gameModel.swipeStatus.restrictDirections(to: .Right)
		
		let addHighlishDto = GameScene.HighlightCircleDto(
			coord: bgCell.position,
			rad: CGFloat(self.gameModel.geometry?.cellHeight ?? 50.0),
			delay: GameConstants.CellAppearAnimationDuration,
			name: TutorialNodeNames.FirstCell)
		NotificationCenter.default.post(name: .addSceneHighlight, object: [addHighlishDto])
		NotificationCenter.default.post(name: .updateSceneDescription, object: "swipe right ➡️") //@todo: translate
		NotificationCenter.default.post(name: .addTutorialSwipeNode, object: SwipeDirection.Right)
	}
}
