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
	var isTutorial: Bool = false // @todo: wrong meaning, this is actually should be named like "isSwiipingHelpScene"
	var predefinedValue: Int?
	
	func setup(addTo bgCell: BgCell, isTutorial: Bool = false, value: Int? = nil) -> GameCMD {
		self.bgCell = bgCell
		self.isTutorial = isTutorial
		self.predefinedValue = value
		return self
	}
	
	override func run() {
		assert(bgCell != nil, "Adding cell to null bgCell")
		guard let bgCell = self.bgCell else {
			return
		}
		
		let newElement = GameCell(
			model: self.gameModel,
			val: self.predefinedValue ?? (Float.random < GameConstants.RandomCellIsValue2Probability ? 1 : 0))
		// @todo: overexposition self settings
		newElement.motionBlurDisabled = !self.gameModel.motionBlurEnabled
		
		if self.isTutorial {
			newElement.updateColorForTutorial()
		}
		
		bgCell.addGameCell(cell: newElement)
		newElement.playAppearAnimation()
		
		bgCell.bonus?.command.run()
		bgCell.removeBonusWithPickingAnimation(0.0)
	}
}
