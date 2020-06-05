//
//  LoadGameCMD.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 06.07.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class LoadGameCmd: GameCMD {
	private var gameSave: SavedGame
	private var screenSize: CGSize
	
	init(_ model: GameModel, save: SavedGame, screen screenSize: CGSize) {
		self.gameSave = save
		self.screenSize = screenSize
		super.init(model)
	}
	
	override func run() {
		// At first, we need to define geometry for loading game
		let coords = gameSave.cells.enumerated().compactMap {
			$1.exist ? AxialCoord($0 % 7, $0 / 7) : nil
		}
		let geometry = FieldGeometry(screenSize: screenSize, coords: coords)
		gameModel.geometry = geometry
		
		// Load cells one by one
		for i in 0..<gameSave.cells.count {
			let loadedCell = gameSave.cells[i]
			
			if !loadedCell.exist {
				continue
			}
			
			let x = i % GameConstants.MaxFieldSize
			let y = i / GameConstants.MaxFieldSize
			
			let coord = AxialCoord(x, y)
			let hexCell = BgCell(
				hexShape: geometry.createHexCellShape(),
				blocked: false,
				coord: coord)
			hexCell.position = geometry.ToScreenCoord(coord)
			
			if loadedCell.blocked {
				hexCell.block()
			}
			else if let val = loadedCell.val {
				let newElement = GameCell(
					model: gameModel,
					val: val)
				hexCell.addGameCell(cell: newElement)
				newElement.playAppearAnimation()
			}
			else if let bonusType = loadedCell.bonusType {
				let bonusNode = BonusFabric.createBy(bonus: bonusType, gameModel: gameModel)
				
				if let bonusTurns = loadedCell.bonusTurns {
					bonusNode.turnsCount = bonusTurns
				}
				
				hexCell.addBonus(bonusNode)
			}
			gameModel.field.setCell(hexCell)
		}
		gameModel.score = gameSave.score
		NotificationCenter.default.post(
			name: .updateScore,
			object: gameModel.score)
		
		gameModel.collectableBonuses = gameSave.bonuses
			.filter { $0.value.currentValue > 0 }
			.mapValues { CollectableBonusModel(currentValue: $0.currentValue, maxValue: $0.maxValue) }
	}
}
