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
		/*for i in 0 ..< self.gameModel.field.height * self.gameModel.field.width {
			let newElement = GameCell(model: self.gameModel, val: i)
			self.gameModel.field[i].addGameCell(cell: newElement)
			newElement.playAppearAnimation()
		}*/

		/*let el1 = GameCell(model: self.gameModel, val: 1)
		self.gameModel.field[3].addGameCell(cell: el1)
		el1.playAppearAnimation()
		self.gameModel.field[9].blockFromSwipe()*/
		
		let el1 = GameCell(model: self.gameModel, val: 0)
		self.gameModel.field[0]?.addGameCell(cell: el1)
		el1.playAppearAnimation()
		
		let el2 = GameCell(model: self.gameModel, val: 0)
		self.gameModel.field[3]?.addGameCell(cell: el2)
		el2.playAppearAnimation()
		
		let el3 = GameCell(model: self.gameModel, val: 5)
		self.gameModel.field[4]?.addGameCell(cell: el3)
		el3.playAppearAnimation()
		
		let el4 = GameCell(model: self.gameModel, val: 5)
		self.gameModel.field[5]?.addGameCell(cell: el4)
		el4.playAppearAnimation()
	}
}
