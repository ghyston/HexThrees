//
//  AddGameCellCMD.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 09.09.19.
//  Copyright © 2019 Ilja Stepanow. All rights reserved.
//

import Foundation

class AddGameCellCmd: GameCMD {
	var bgCell: BgCell?
	var isTutorial: Bool = false
	
	func setup(addTo bgCell: BgCell, _ isTutorial: Bool = false) -> GameCMD {
		self.bgCell = bgCell
		self.isTutorial = isTutorial
		return self
	}
	
	override func run() {
		assert(bgCell != nil, "Adding cell to null bgCell")
		guard let bgCell = self.bgCell else {
			return
		}
		
		let newElement = GameCell(
			model: self.gameModel,
			val: Float.random < GameConstants.RandomCellIsValue2Probability ? 1 : 0)
		// @todo: overexposition self settings
		newElement.motionBlurDisabled = !self.gameModel.motionBlurEnabled
		
		if isTutorial {
			newElement.updateColorForTutorial()
		}
		
		bgCell.addGameCell(cell: newElement)
		newElement.playAppearAnimation()
		
		bgCell.bonus?.command.run()
		bgCell.removeBonusWithPickingAnimation(0.0)
	}
}
