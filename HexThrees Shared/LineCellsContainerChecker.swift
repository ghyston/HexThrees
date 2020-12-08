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
    
    private func haveBonus(cell: BgCell) -> Bool {
        return cell.bonus != nil
    }
    
    // Used to find best possible swipe. For fucking preview video, that I dont want to do manually
    func checkScore(strategy: MergingStrategy, from: Int = 0) -> Int {
        guard let first = findNext(startIndex: from, condition: notEmpty) else {
            return 0
        }
        
        var outcome = 0
        if findNext(startIndex: from, condition: haveBonus) != nil {
            outcome = 5
        }
        
        // if it was last cell in line
        if first.index == count - 1 {
            return outcome
        }
        
        guard let nextCell = findNext(startIndex: first.index + 1, condition: notEmpty) else {
            return outcome + 1 // next cell not found, all cells empty
        }
        
        if let score = strategy.isSiblings(nextCell.cell.gameCell!.value, first.cell.gameCell!.value) {
            return outcome + score * 100 // Int(powl(2.0, Double(score)))
        }
        // If not may be next and next after next can be merged?
        else {
            return outcome + checkScore(strategy: strategy, from: from + 1)
        }
    }
}
