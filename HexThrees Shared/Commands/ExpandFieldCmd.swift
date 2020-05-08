//
//  IncreaseFieldSize.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 27.04.20.
//  Copyright © 2020 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

class ExpandFieldCalculator: ICellsStatisticCalculator {
	var potentialParentCells: Int = 0
	var totalCells: Int = 0
	
	func next(socket: BgCell?) {
		totalCells += 1
		if socket != nil && socket?.isBlocked == false {
			potentialParentCells += 1
		}
	}
	
	func probability() -> Float {
		totalCells == 0 ? 0.0 : Float(potentialParentCells) / Float(totalCells)
	}
	
	func clean() {
		potentialParentCells = 0
		totalCells = 0
	}
}

class ExpandFieldCmd : GameCMD {
	override func run() {
		
		let emptySockets = self.gameModel.field.getSockets(compare: HexField.isNotSet)
		let dice = ProbabilityArray<AxialCoord>()
		let calc = ExpandFieldCalculator()
		var icalc: ICellsStatisticCalculator = calc
		
		for socketCoord in emptySockets {
			gameModel.field.calculateForSiblings(coord: socketCoord, calc: &icalc)
			dice.add(socketCoord, calc.probability())
		}
		
		guard let emptySocketCoord = dice.getRandom() else {
			assert(true, "ExpandFieldCmd: random empty pocket not exist!")
			return
		}
		
		guard let geometry = self.gameModel.geometry else {
			assert(true, "ExpandFieldCmd: empty pocket not exist!")
			return
		}
		
		let parent = gameModel.field.getSiblings(
			coord: emptySocketCoord,
			compare: HexField.notBlockedCell)
		
		let hexCell = BgCell(
			hexShape: geometry.createHexCellShape(),
			blocked: false,
			coord: emptySocketCoord)
		
		let newPosition = geometry.ToScreenCoord(emptySocketCoord)
		hexCell.position = parent.randomElement()?.position ?? newPosition
		let moveAction = SKAction.move(to: newPosition, duration: 1.0) //@todo: correct expand duration
		hexCell.run(moveAction)
		
		self.gameModel.field.setCell(hexCell)
		NotificationCenter.default.post(name: .expandField, object: hexCell)
		
		//@todo: move here logic from GameVC
	}
}
