//
//  ExpandHexFieldCmd.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 08.05.20.
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
		totalCells == 0 ? 0.0 : pow(Float(potentialParentCells) / Float(totalCells), 2)
	}
	
	func clean() {
		potentialParentCells = 0
		totalCells = 0
	}
}

class ExpandHexFieldCmd : GameCMD {
	
	var viewSize: CGSize?
	weak var scene: GameScene?
	
	func setup(viewSize: CGSize, scene: GameScene) {
		self.viewSize = viewSize
		self.scene = scene
	}
	
	override func run() {
		// Find place to put new cell and parent cell
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
		
		guard let oldGeometry = self.gameModel.geometry else {
			assert(true, "ExpandFieldCmd: geometry is a failure as a concept")
			return
		}
		
		let parent = gameModel.field.getSiblings(
			coord: emptySocketCoord,
			compare: HexField.notBlockedCell)
		
		// Create new BgCell
		let hexCell = BgCell(
			hexShape: oldGeometry.createBgCellShape(),
			blocked: false,
			coord: emptySocketCoord)
		
		// Move cell to new position from parent
		let newPosition = oldGeometry.ToScreenCoord(emptySocketCoord)
		let oldPosition = parent.randomElement()?.position ?? newPosition
		hexCell.position = oldPosition
		let moveAction = SKAction.move(
			to: newPosition,
			duration: GameConstants.ExpandFieldAnimationDuration)
			.with(mode: SKActionTimingMode.easeIn)
		hexCell.run(moveAction)
		
		// Add to model and to view
		self.gameModel.field.setCell(hexCell)
		self.scene?.addChild(hexCell)
		
		// Create field outline cell
		let pal: IPaletteManager = ContainerConfig.instance.resolve()
		self.scene?.addFieldOutlineCell(
			where: hexCell.coord,
			startPos: oldPosition,
			color: pal.fieldOutlineColor(),
			using: oldGeometry)
		
		// Create new geometry and check, do we need to scale field
		let newGeometry = FieldGeometry(
			screenSize: viewSize!,
			coords: self.gameModel.field.coordinates())
		
		if newGeometry.compare(to: oldGeometry) {
			return
		}
		
		// update geometry, hex fields and field outline
		let scale = CGFloat(oldGeometry.hexScale(to: newGeometry))
		let path = newGeometry.hexCellPath
		self.gameModel.geometry = newGeometry
		
		self.gameModel.field.executeForAll(lambda: { (bgCell: BgCell) in
			let coordinates = newGeometry.ToScreenCoord(bgCell.coord)
			bgCell.updateShape(
				scale: scale,
				coordinates: coordinates,
				path: path)
		})
		
		self.scene?.scaleFieldOutline(by: scale, self.gameModel)
	}
	
}
