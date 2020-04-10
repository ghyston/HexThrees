//
//  LineCellsContainerChecker.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 23.04.19.
//  Copyright © 2019 Ilja Stepanow. All rights reserved.
//

import Foundation

extension LineCellsContainer {
	private func notEmpty(cell: BgCell) -> Bool {
		return cell.gameCell != nil
	}
	
	func check(strategy: MergingStrategy, from: Int = 0) -> Bool {
		guard let first = findNext(startIndex: from, condition: notEmpty) else {
			return false
		}
		
		// if it was last cell in line
		if first.index == count - 1 {
			return false
		}
		
		let nextCell = cells[first.index + 1]
		
		// If next cell is empty, line can be moved
		if !notEmpty(cell: nextCell) {
			return true
		}
		else {
			// If first and next cell can be merged, we are fine
			if strategy.isSiblings(first.cell.gameCell!.value, nextCell.gameCell!.value) != nil {
				return true
			}
			// If not may be next and next after next can be merged?
			else {
				return check(strategy: strategy, from: from + 1)
			}
		}
	}
}
