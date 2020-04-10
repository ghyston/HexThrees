//
//  MoveXDownIterator.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 30.09.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class MoveXDownIterator: BaseCellsIterator, CellsIterator {
	func next() -> LineCellsContainer? {
		line.clear()
		
		if x >= w {
			x = 0
			y += 1
		}
		
		if y >= h {
			return nil
		}
		
		for _ in x ..< w {
			let cell = getCell(x, y)
			
			x += 1
			
			if cell.isBlocked || cell.isBlockedFromSwipe {
				break
			}
			
			line.add(cell)
		}
		
		return line
	}
}
