//
//  TutorialMoveToPickBonusCmd.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 01.06.20.
//  Copyright © 2020 Ilja Stepanow. All rights reserved.
//

import Foundation

class TutorialMoveToPickBonusCmd : GameCMD {
	
	var direction : SwipeDirection
	
	init(_ gameModel: GameModel, to direction: SwipeDirection) {
		self.direction = direction
		super.init(gameModel)
	}
	
	override func run() {
		let coord = direction == .Left
			? self.gameModel.geometry!.ToScreenCoord(AxialCoord(2, 4))
			: self.gameModel.geometry!.ToScreenCoord(AxialCoord(4, 2))
		
		let moveCellHighlightDto = GameScene.HighlightCircleDto(
			coord: coord,
			rad: 0,
			delay: nil,
			name: TutorialNodeNames.FirstCell)
		NotificationCenter.default.post(name: .moveSceneHighlight, object: moveCellHighlightDto)
		
		let moveBonusHighlightDto = GameScene.HighlightCircleDto(
			coord: coord,
			rad: 0,
			delay: nil,
			name: TutorialNodeNames.BonusCell)
		NotificationCenter.default.post(name: .moveSceneHighlight, object: moveBonusHighlightDto)
		NotificationCenter.default.post(name: .updateSceneDescription, object: "")
	}
}
