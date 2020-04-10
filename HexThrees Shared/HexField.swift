//
//  CellsGrid.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 26.08.19.
//  Copyright © 2019 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

typealias CellComparator = (_ cell: BgCell) -> Bool

protocol ICellsStatisticCalculator {
	func next(cell: BgCell)
	func clean()
}

class HexField {
	private var bgHexes = [BgCell]()
	let width: Int
	let height: Int
	
	init(width: Int, height: Int, geometry: FieldGeometry) {
		self.width = width
		self.height = height
		
		for i2 in 0 ..< width {
			for i1 in 0 ..< height {
				let coord = AxialCoord(i2, i1)
				let hexCell = BgCell(
					hexShape: geometry.createHexCellShape(),
					blocked: false,
					coord: coord)
				hexCell.position = geometry.ToScreenCoord(coord)
				bgHexes.append(hexCell)
			}
		}
	}
	
	func clean() {
		for i in 0 ..< bgHexes.count {
			self[i].removeAllActions()
			self[i].removeFromParent()
		}
		bgHexes.removeAll()
	}
	
	subscript(index: Int) -> BgCell {
		return bgHexes[index]
	}
	
	subscript(x: Int, y: Int) -> BgCell {
		assert(x >= 0 && x < width, "cell coordinate \(x) out of range")
		assert(y >= 0 && y < height, "cell coordinate \(y) out of range")
		let index = y * width + x
		return bgHexes[index]
	}
	
	func getCell(_ x: Int, _ y: Int) -> BgCell {
		assert(x >= 0 && x < width, "cell coordinate \(x) out of range")
		assert(y >= 0 && y < height, "cell coordinate \(y) out of range")
		let index = y * width + x
		return bgHexes[index]
	}
	
	func getBgCells(compare: CellComparator) -> [BgCell] {
		return bgHexes.filter(compare)
	}
	
	func hasBgCells(compare: CellComparator) -> Bool {
		return bgHexes.first(where: compare) != nil
	}
	
	func getBgCellsWithPriority(
		required: CellComparator,
		priority: CellComparator...) -> [BgCell] {
		let cells = getBgCells(compare: required)
		var preferedCells = cells
		for preferFilter in priority {
			preferedCells = preferedCells.filter(preferFilter)
		}
		return preferedCells.count > 0 ? preferedCells : cells
	}
	
	func countBgCells(compare: CellComparator) -> Int {
		return bgHexes.filter(compare).count
	}
	
	func executeForAll(lambda: (_: BgCell) -> Void) {
		for i in 0 ..< bgHexes.count {
			lambda(self[i])
		}
	}
	
	// MARK: Cell selectors
	
	class func freeCell(cell: BgCell) -> Bool {
		return cell.gameCell == nil && !cell.isBlocked
	}
	
	class func freeCellWoBonuses(cell: BgCell) -> Bool {
		return cell.gameCell == nil && !cell.isBlocked &&
			cell.bonus == nil
	}
	
	class func blockedCell(cell: BgCell) -> Bool {
		return cell.isBlocked
	}
	
	class func notBlockedCell(cell: BgCell) -> Bool {
		return !cell.isBlocked
	}
	
	class func cellWoBonuses(cell: BgCell) -> Bool {
		return cell.bonus == nil
	}
	
	class func cellWoShader(cell: BgCell) -> Bool {
		return cell.shape?.fillShader == nil
	}
	
	class func userBlockedCell(cell: BgCell) -> Bool {
		return cell.isBlockedFromSwipe
	}
	
	class func containGameCell(cell: BgCell) -> Bool {
		return cell.gameCell != nil
	}
	
	//    func executeForAll(lambda: (_:BgCell, _: Int, _: Int) -> Void) {
	//        for y in 0 ..< height {
	//            for x in 0 ..< width {
	//                lambda(self[x, y], x, y)
	//            }
	//        }
	//    }
//
	//    func executeForAll(lambda: (_:BgCell, _: Int) -> Void) {
	//        for i in 0 ..< height * width {
	//            lambda(self[i], i)
	//        }
	//    }
	
	func calculateForSiblings(coord: AxialCoord, calc: inout ICellsStatisticCalculator) {
		calc.clean()
		
		let xMin = max(coord.c - 1, 0)
		let xMax = min(coord.c + 1, width - 1)
		let yMin = max(coord.r - 1, 0)
		let yMax = min(coord.r + 1, height - 1)
		
		for x in xMin ... xMax {
			for y in yMin ... yMax {
				// here skipping self cell and corner cells (because of hex geometry)
				if (x == coord.c && y == coord.r) || x == y {
					continue
				}
				
				calc.next(cell: self[x, y])
			}
		}
	}
}
