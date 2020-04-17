//
//  CreateCellsFromAllPaletteCMD.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 14.06.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class DebugPaletteCMD: GameCMD {
	override func run() {
		for i in 0 ..< self.gameModel.field.height * self.gameModel.field.width {
			let newElement = GameCell(model: self.gameModel, val: i)
			self.gameModel.field[i].addGameCell(cell: newElement)
			newElement.playAppearAnimation()
		}

		/*let el1 = GameCell(model: self.gameModel, val: 1)
		self.gameModel.field[3].addGameCell(cell: el1)
		el1.playAppearAnimation()
		self.gameModel.field[9].blockFromSwipe()*/
	}
}
