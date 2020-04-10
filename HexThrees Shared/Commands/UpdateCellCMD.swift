//
//  UpdateCellCMD.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 28.05.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class UpdateCellCMD : GameCMD {
	
	var cell : GameCell?
	var value : Int?
	var direction: SwipeDirection?
	
	func setup(cell: GameCell, value: Int, from direction: SwipeDirection) -> UpdateCellCMD {
		self.cell = cell
		self.value = value
		self.direction = direction
		return self
	}
	
	override func run() {
		self.cell?.updateValue(
			value: self.value!,
			strategy: self.gameModel.strategy,
			direction: direction)
	}
	
}
