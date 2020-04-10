//
//  PaletteManager.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 07.06.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

protocol IPaletteManager {
	func fieldOutlineColor() -> SKColor
	func cellBgColor() -> SKColor
	func sceneBgColor() -> SKColor
	func cellBlockedBgColor() -> SKColor
	func cellBlockingLinesColor() -> SKColor
	func color(value: Int) -> SKColor
	func switchPalette(to: ColorSchemaType)
	func statusBarStyle() -> UIStatusBarStyle
	func cellTutorialColor() -> SKColor
	
	// @todo: add cells stroke color, font color
}

class PaletteManager: IPaletteManager {
	private var currentPalette: ColorSchema
	private let allPalettes: [ColorSchemaType: ColorSchema]
	
	init(_ currentShema: ColorSchemaType) {
		// @todo: try for background 333240
		
		let dark = ColorSchema(
			fieldOutlineColor: UIColor(rgb: 0x333333),
			sceneBgColor: .black,
			cellBgColor: SKColor(rgb: 0x808080),
			cellBlockedBgColor: SKColor(rgb: 0x555555),
			cellBlockingLinesColor: SKColor(rgb: 0xA0A0A0),
			cellTutorialColor: .white,
			statusBarStyle: .lightContent,
			colors: [0: SKColor(rgb: 0xE0D688),
					 1: SKColor(rgb: 0xDFB138),
					 2: SKColor(rgb: 0xDE6C4C),
					 3: SKColor(rgb: 0x647F5A),
					 4: SKColor(rgb: 0x61709F),
					 5: SKColor(rgb: 0xDB5784),
					 6: SKColor(rgb: 0x92A075),
					 7: SKColor(rgb: 0x83789F),
					 8: SKColor(rgb: 0x79BA63),
					 9: SKColor(rgb: 0xFF9000),
					 10: SKColor(rgb: 0x357736),
					 11: SKColor(rgb: 0xB24B36),
					 12: SKColor(rgb: 0x216596),
					 13: SKColor(rgb: 0x07BEB8),
					 14: SKColor(rgb: 0x406C8B),
					 15: SKColor(rgb: 0x9CEAEF),
					 16: SKColor(rgb: 0x8DD3D8),
					 17: SKColor(rgb: 0x7EBCC1),
					 18: SKColor(rgb: 0x6FA5AA),
					 19: SKColor(rgb: 0x608E93),
					 20: SKColor(rgb: 0x51777C),
					 21: SKColor(rgb: 0x426065),
					 22: SKColor(rgb: 0x33494E),
					 23: SKColor(rgb: 0x243237),
					 24: SKColor(rgb: 0x151B20)])
		
		let gray = ColorSchema(
			fieldOutlineColor: .darkGray,
			sceneBgColor: .white,
			cellBgColor: SKColor(rgb: 0x808080),
			cellBlockedBgColor: SKColor(rgb: 0x555555),
			cellBlockingLinesColor: SKColor(rgb: 0xA0A0A0),
			cellTutorialColor: .white,
			statusBarStyle: .lightContent,
			colors: [0: SKColor(rgb: 0xE0D688),
					 1: SKColor(rgb: 0xDFB138),
					 2: SKColor(rgb: 0xDE6C4C),
					 3: SKColor(rgb: 0x647F5A),
					 4: SKColor(rgb: 0x61709F),
					 5: SKColor(rgb: 0xDB5784),
					 6: SKColor(rgb: 0x92A075),
					 7: SKColor(rgb: 0x83789F),
					 8: SKColor(rgb: 0x79BA63),
					 9: SKColor(rgb: 0xFF9000),
					 10: SKColor(rgb: 0x357736),
					 11: SKColor(rgb: 0xB24B36),
					 12: SKColor(rgb: 0x216596),
					 13: SKColor(rgb: 0x07BEB8),
					 14: SKColor(rgb: 0x406C8B),
					 15: SKColor(rgb: 0x9CEAEF),
					 16: SKColor(rgb: 0x8DD3D8),
					 17: SKColor(rgb: 0x7EBCC1),
					 18: SKColor(rgb: 0x6FA5AA),
					 19: SKColor(rgb: 0x608E93),
					 20: SKColor(rgb: 0x51777C),
					 21: SKColor(rgb: 0x426065),
					 22: SKColor(rgb: 0x33494E),
					 23: SKColor(rgb: 0x243237),
					 24: SKColor(rgb: 0x151B20)])
		
		let light = ColorSchema(
			fieldOutlineColor: .gray,
			sceneBgColor: .white,
			cellBgColor: SKColor(rgb: 0x101010),
			cellBlockedBgColor: SKColor(rgb: 0x555555),
			cellBlockingLinesColor: SKColor(rgb: 0xA0A0A0),
			cellTutorialColor: .white,
			statusBarStyle: .default,
			colors: [0: SKColor(rgb: 0xE0D688),
					 1: SKColor(rgb: 0xDFB138),
					 2: SKColor(rgb: 0xDE6C4C),
					 3: SKColor(rgb: 0x647F5A),
					 4: SKColor(rgb: 0x61709F),
					 5: SKColor(rgb: 0xDB5784),
					 6: SKColor(rgb: 0x92A075),
					 7: SKColor(rgb: 0x83789F),
					 8: SKColor(rgb: 0x79BA63),
					 9: SKColor(rgb: 0xFF9000),
					 10: SKColor(rgb: 0x357736),
					 11: SKColor(rgb: 0xB24B36),
					 12: SKColor(rgb: 0x216596),
					 13: SKColor(rgb: 0x07BEB8),
					 14: SKColor(rgb: 0x406C8B),
					 15: SKColor(rgb: 0x9CEAEF),
					 16: SKColor(rgb: 0x8DD3D8),
					 17: SKColor(rgb: 0x7EBCC1),
					 18: SKColor(rgb: 0x6FA5AA),
					 19: SKColor(rgb: 0x608E93),
					 20: SKColor(rgb: 0x51777C),
					 21: SKColor(rgb: 0x426065),
					 22: SKColor(rgb: 0x33494E),
					 23: SKColor(rgb: 0x243237),
					 24: SKColor(rgb: 0x151B20)])
		
		allPalettes = [
			.Dark: dark,
			.Light: light,
			.Gray: gray,
		]
		
		currentPalette = allPalettes[currentShema]!
	}
	
	func color(value: Int) -> SKColor {
		let color = currentPalette.colors[value]
		assert(color != nil, "PaletteManager: color for value \(value) not found")
		return color!
	}
	
	func cellBgColor() -> SKColor {
		return currentPalette.cellBgColor
	}
	
	func sceneBgColor() -> SKColor {
		return currentPalette.sceneBgColor
	}
	
	func cellBlockedBgColor() -> SKColor {
		return currentPalette.cellBlockedBgColor
	}
	
	func cellBlockingLinesColor() -> SKColor {
		return currentPalette.cellBlockingLinesColor
	}
	
	func fieldOutlineColor() -> SKColor {
		return currentPalette.fieldOutlineColor
	}
	
	func statusBarStyle() -> UIStatusBarStyle {
		return currentPalette.statusBarStyle
	}
	
	func cellTutorialColor() -> SKColor {
		return currentPalette.cellTutorialColor
	}
	
	func switchPalette(to colorSchemaType: ColorSchemaType) {
		let pal = allPalettes[colorSchemaType]
		assert(pal != nil, "Palette \(colorSchemaType) not exist")
		currentPalette = pal!
	}
}
