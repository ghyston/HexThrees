//
//  TutorialStepMoveFirstCellCmd.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 29.05.20.
//  Copyright © 2020 Ilja Stepanow. All rights reserved.
//

import Foundation

class TutorialStepMoveFirstCellCmd: GameCMD {
	override func run() {
		let moveHighlightDto = GameScene.HighlightCircleDto(
			coord: self.gameModel.geometry!.ToScreenCoord(AxialCoord(4, 2)),
			rad: 0,
			delay: nil,
			name: TutorialNodeNames.FirstCell)
		NotificationCenter.default.post(name: .moveSceneHighlight, object: moveHighlightDto)
	}
}