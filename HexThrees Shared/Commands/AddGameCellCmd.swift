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
	
	func setup(addTo bgCell: BgCell) -> GameCMD {
		self.bgCell = bgCell
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
		
		bgCell.addGameCell(cell: newElement)
		newElement.playAppearAnimation()
		
		bgCell.bonus?.command.run()
		bgCell.removeBonusWithPickingAnimation(0.0)
	}
}
