//
//  FieldBg.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 29.10.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

class FieldOutlineHex: SKShapeNode {
	let coord: AxialCoord
	
	init(coord: AxialCoord, using geometry: FieldGeometry) {
		self.coord = coord
		super.init()
		self.path = geometry.outlinePath
		self.lineWidth = 0
		self.position = geometry.ToScreenCoord(coord)
	}
	
	func updateShape(scale: CGFloat, using geometry: FieldGeometry) {
		let duration = GameConstants.ExpandFieldAnimationDuration
		
		self.xScale = 1.0 / scale
		self.yScale = 1.0 / scale
		self.path = geometry.outlinePath
		
		self.run(SKAction.scale(to: 1.0, duration: duration).with(mode: SKActionTimingMode.easeIn))
		self.run(SKAction.move(to: geometry.ToScreenCoord(self.coord), duration: duration).with(mode: SKActionTimingMode.easeIn))
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

class FieldOutline: SKNode {
	static let defaultNodeName = "fieldBg"
	
	func recalculateFieldBg(model: GameModel) {
		self.removeAllChildren()
		
		for y in 0 ..< model.field.height {
			for x in 0 ..< model.field.width {
				if model.field[x, y] == nil {
					continue
				}
				
				let hexShape = FieldOutlineHex(
					coord: AxialCoord(x, y),
					using: model.geometry!)
				hexShape.fillColor = .darkGray
				self.addChild(hexShape)
			}
		}
	}
	
	func addFieldOutlineCell(where coord: AxialCoord, startPos: CGPoint, color: SKColor, using geometry: FieldGeometry) {
		let hexShape = FieldOutlineHex(
			coord: coord,
			using: geometry)
		hexShape.fillColor = color
		
		let oldPos = hexShape.position
		hexShape.position = startPos
		hexShape.run(SKAction
			.move(
				to: oldPos,
				duration: GameConstants.ExpandFieldAnimationDuration)
			.with(mode: SKActionTimingMode.easeIn))
		self.addChild(hexShape)
	}
	
	func updateColor(color: SKColor) {
		for child in children {
			if let shape = child as? SKShapeNode {
				shape.fillColor = color
			}
		}
	}
	
	func updateGeometry(by scale: CGFloat, using geometry: FieldGeometry) {
		for child in children {
			guard let fieldOunlineHex = child as? FieldOutlineHex else {
				continue
			}
			
			fieldOunlineHex.updateShape(scale: scale, using: geometry)
		}
	}
}
