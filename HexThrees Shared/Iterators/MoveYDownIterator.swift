//
//  MoveLeftIterator.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 26.09.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class MoveYDownIterator: BaseCellsIterator, CellsIterator {
	func next() -> LineCellsContainer? {
		line.clear()
		
		if y >= h {
			y = 0
			x += 1
		}
		
		if x >= w {
			return nil
		}
		
		for _ in y ..< h {
			let cell = getCell(x, y)
			
			y += 1
			
			if cell.isBlocked || cell.isBlockedFromSwipe {
				break
			}
			
			line.add(cell)
		}
		
		return line
	}
}
