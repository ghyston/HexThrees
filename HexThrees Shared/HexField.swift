//
//  CellsGrid.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 26.08.19.
//  Copyright © 2019 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

//note: socket is plave for bgCell
typealias CellComparator = (_ cell: BgCell) -> Bool
typealias SocketComparator = (_ socket: BgCell?) -> Bool

protocol ICellsStatisticCalculator {
	func next(socket: BgCell?)
	func clean()
}

class EmptyCellNearbyFinder: ICellsStatisticCalculator {
	var emptyCellExist: Bool = false
	
	func next(socket: BgCell?) {
		emptyCellExist = emptyCellExist || socket == nil
	}
	
	func clean() {
		emptyCellExist = false
	}
}

class HexField {
	private var bgHexes = [BgCell?](repeating: nil, count: GameConstants.MaxFieldSize * GameConstants.MaxFieldSize)
	let width: Int = GameConstants.MaxFieldSize
	let height: Int = GameConstants.MaxFieldSize
	
	func setupNewField(model: GameModel, screenSize: CGSize) {
		var coords = [AxialCoord]()
		
		let start = (GameConstants.MaxFieldSize - GameConstants.StartFieldSize) / 2
		let end = start + GameConstants.StartFieldSize
		
		for y in start ..< end {
			for x in start ..< end {
				coords.append(AxialCoord(x, y))
			}
		}
		
		let geometry = FieldGeometry(screenSize: screenSize, coords: coords)
		model.geometry = geometry
		
		for coord in coords {
			let hexCell = BgCell(
				hexShape: geometry.createHexCellShape(),
				blocked: false,
				coord: coord)
			hexCell.position = geometry.ToScreenCoord(coord)
			setCell(hexCell)
		}
	}
	
	func clean() {
		for i in 0 ..< bgHexes.count {
			self[i]?.removeAllActions()
			self[i]?.removeFromParent()
		}
		bgHexes.removeAll()
	}
	
	subscript(index: Int) -> BgCell? {
		bgHexes[index]
	}
	
	subscript(x: Int, y: Int) -> BgCell? {
		getCell(x, y)
	}
	
	func setCell(_ cell: BgCell) {
		let index = cell.coord.c + cell.coord.r * GameConstants.MaxFieldSize
		assert(bgHexes[index] == nil, "BgCell already exist")
		bgHexes[index] = cell
	}
	
	func getCell(_ x: Int, _ y: Int) -> BgCell? {
		assert(x >= 0 && x < width, "cell coordinate \(x) out of range")
		assert(y >= 0 && y < height, "cell coordinate \(y) out of range")
		let index = y * width + x
		return bgHexes[index]
	}
	
	func getBgCells(compare: CellComparator) -> [BgCell] {
		return bgHexes.compactMap { $0 }.filter(compare)
	}
	
	func hasBgCells(compare: CellComparator) -> Bool {
		bgHexes.compactMap { $0 }.contains(where: compare)
	}
	
	func getSockets(compare: SocketComparator) -> [AxialCoord] {
		var result = [AxialCoord]()
		for y in 0 ..< height {
			for x in 0 ..< width {
				if compare(bgHexes[y * width + x]) {
					result.append(AxialCoord(x, y))
				}
			}
		}
		
		return result
	}
	
	func hasSockets(compare: SocketComparator) -> Bool {
		bgHexes.contains(where: compare)
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
		return bgHexes.compactMap { $0 }.filter(compare).count
	}
	
	func executeForAll(lambda: (_: BgCell) -> Void) {
		for i in 0 ..< bgHexes.count {
			guard let cell = self[i] else {
				continue
			}
			lambda(cell)
		}
	}
	
	func executeForEverySocket(lambda: (_: BgCell?) -> Void) {
		for i in 0 ..< bgHexes.count {
			lambda(self[i])
		}
	}
	
	// MARK: Cell selectors
	
	class func freeCell(cell: BgCell) -> Bool {
		cell.gameCell == nil && !cell.isBlocked
	}
	
	class func freeCellWoBonuses(cell: BgCell) -> Bool {
		cell.gameCell == nil && !cell.isBlocked &&
			cell.bonus == nil
	}
	
	class func blockedCell(cell: BgCell) -> Bool {
		cell.isBlocked
	}
	
	class func notBlockedCell(cell: BgCell) -> Bool {
		!cell.isBlocked
	}
	
	class func cellWoBonuses(cell: BgCell) -> Bool {
		cell.bonus == nil
	}
	
	class func cellWoShader(cell: BgCell) -> Bool {
		cell.hexShape.fillShader == nil
	}
	
	class func userBlockedCell(cell: BgCell) -> Bool {
		cell.isBlockedFromSwipe
	}
	
	class func containGameCell(cell: BgCell) -> Bool {
		cell.gameCell != nil
	}
	
	class func isNotSet(socket: BgCell?) -> Bool {
		socket == nil
	}
	
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
				
				calc.next(socket: self[x, y])
			}
		}
	}
}
