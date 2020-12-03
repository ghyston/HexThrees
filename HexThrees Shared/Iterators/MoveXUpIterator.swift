//
//  MoveXUpIterator.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 30.09.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class MoveXUpIterator: BaseCellsIterator, CellsIterator {
	override init(_ gameModel: GameModel) {
		super.init(gameModel)
		x = w - 1
	}
	
	func next() -> LineCellsContainer? {
		line.clear()
		
		if x < 0 {
			x = w - 1
			y += 1
		}
		
		if y >= h {
			return nil
		}
		
		for _ in 0 ... x {
			defer { x -= 1 }
			
			guard let cell = getCell(x, y),
				!cell.isBlocked,
				!cell.isBlockedFromSwipe
			else { break }
			
			line.add(cell)
		}
		
		return line
	}
}
