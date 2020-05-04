//
//  IncreaseFieldSize.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 27.04.20.
//  Copyright © 2020 Ilja Stepanow. All rights reserved.
//

import Foundation

class ExpandFieldCmd : GameCMD {
	override func run() {
		
		guard let emptySocketCoord = self.gameModel.field.getSockets(compare: HexField.isNotSet).randomElement() else {
			assert(true, "ExpandFieldCmd: empty pocket not exist!")
			return
		}
		
		guard let geometry = self.gameModel.geometry else {
			assert(true, "ExpandFieldCmd: empty pocket not exist!")
			return
		}
		
		let hexCell = BgCell(
			hexShape: geometry.createHexCellShape(),
			blocked: false,
			coord: emptySocketCoord)
		hexCell.position = geometry.ToScreenCoord(emptySocketCoord)
		self.gameModel.field.setCell(hexCell)
		NotificationCenter.default.post(name: .expandField, object: hexCell)
	}
}
