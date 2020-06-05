//
//  TutorialAvoidTimerCmd.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 05.06.20.
//  Copyright © 2020 Ilja Stepanow. All rights reserved.
//

import Foundation

class TutorialAvoidTimerCmd : GameCMD {
	
	var direction : SwipeDirection?
	
	func setup(to direction: SwipeDirection) -> GameCMD {
		self.direction = direction
		return self
	}
	
	override func run() {
		let coord = direction == .XDown
			? self.gameModel.geometry!.ToScreenCoord(AxialCoord(2, 4))
			: self.gameModel.geometry!.ToScreenCoord(AxialCoord(4, 2))
		
		let moveCellHighlightDto = GameScene.HighlightCircleDto(
			coord: coord,
			rad: 0,
			delay: nil,
			name: TutorialNodeNames.FirstCell)
		
		NotificationCenter.default.post(name: .moveSceneHighlight, object: moveCellHighlightDto)
		NotificationCenter.default.post(name: .updateSceneDescription, object: "")
	}
}
