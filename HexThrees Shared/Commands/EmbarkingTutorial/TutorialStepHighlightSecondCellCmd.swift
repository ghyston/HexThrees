//
//  TutorialStepHighlightSecondCellCmd.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 29.05.20.
//  Copyright © 2020 Ilja Stepanow. All rights reserved.
//

import Foundation

class TutorialStepHighlightSecondCellCmd: GameCMD {
	override func run() {
		guard let bgCellForNewCell = self.gameModel.field[4, 4] else {
			assert(false, "TutorialStep2Cmd: BgCell with coordinates (4, 4) is not exist")
			return
		}

		AddGameCellCmd(self.gameModel).setup(addTo: bgCellForNewCell, isTutorial: false, value: 0).run()
		self.gameModel.swipeStatus.restrictDirections(to: .YUp)
		
		let highlightDto = GameScene.HighlightCircleDto(
			coord: self.gameModel.geometry!.ToScreenCoord(AxialCoord(4, 4)),
			rad: CGFloat(self.gameModel.geometry?.cellHeight ?? 50.0),
			delay: 0.2,
			name: TutorialNodeNames.SecondCell)
		
		NotificationCenter.default.post(name: .addSceneHighlight, object: [highlightDto])
		NotificationCenter.default.post(name: .updateSceneDescription, object: "swipe up-left\nto combine cells ↖︎")
		//@todo: add swipe node
	}
}
