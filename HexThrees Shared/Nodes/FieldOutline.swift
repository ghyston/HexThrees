//
//  FieldBg.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 29.10.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

class FieldOutline: SKNode {
	static let defaultNodeName = "fieldBg"

	func recalculateFieldBg(model: GameModel) {
		self.removeAllChildren()

		for y in 0 ..< model.field.height {
			for x in 0 ..< model.field.width {
				if model.field[x, y] == nil {
					continue
				}
				
				let hexShape = model.geometry!.createOutlineShape()
				hexShape.fillColor = .darkGray
				hexShape.lineWidth = 0
				hexShape.position = model.geometry!.ToScreenCoord(AxialCoord(x, y))
				self.addChild(hexShape)
			}
		}
	}

	func updateColor(color: SKColor) {
		for child in children {
			if let shape = child as? SKShapeNode {
				shape.fillColor = color
			}
		}
	}
}
