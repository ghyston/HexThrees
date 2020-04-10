//
//  LabeledNode.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 04.12.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

protocol LabeledNode: class {
	var label: SKLabelNode { get set }
	
	func addLabel(text: String)
	func updateText(text: String)
	func updateColor(fontColor: SKColor)
}

extension LabeledNode where Self: SKNode {
	func addLabel(text: String) {
		label = SKLabelNode()
		label.verticalAlignmentMode = .center
		label.fontName = "Futura"
		label.position = CGPoint(x: 0, y: 0)
		label.zPosition = zPositions.labelZ.rawValue
		
		updateText(text: text)
		
		addChild(label)
	}
	
	func updateText(text: String) {
		label.text = text
		
		switch text.count {
		case 1:
			label.fontSize = 24
		case 1..<5:
			label.fontSize = 22
		case 5:
			label.fontSize = 20
		case 6:
			label.fontSize = 16
		case 7:
			label.fontSize = 14
		default:
			label.fontSize = 10
		}
	}
	
	func updateColor(fontColor: SKColor) {
		label.fontColor = fontColor
	}
}
