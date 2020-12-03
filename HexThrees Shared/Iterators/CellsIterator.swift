//
//  CellsIterator.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 27.09.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

protocol CellsIterator {
	func next() -> LineCellsContainer?
}

class BaseCellsIterator {
	internal let gameModel: GameModel
	internal var line = LineCellsContainer()
	
	internal var y: Int = 0
	internal var x: Int = 0
	internal var w: Int { self.gameModel.field.width }
	internal var h: Int { self.gameModel.field.height }
	
	init(_ gameModel: GameModel) {
		self.gameModel = gameModel
	}
	
	internal func getCell(_ x: Int, _ y: Int) -> BgCell? { self.gameModel.field[x, y] }
}
