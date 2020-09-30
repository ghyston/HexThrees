//
//  SKColor.extensions.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 07.06.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

// @note: https://stackoverflow.com/questions/24263007/how-to-use-hex-colour-values
extension SKColor {
	convenience init(red: Int, green: Int, blue: Int) {
		assert(red >= 0 && red <= 255, "Invalid red component")
		assert(green >= 0 && green <= 255, "Invalid green component")
		assert(blue >= 0 && blue <= 255, "Invalid blue component")
		
		self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
	}
	
	convenience init(rgb: Int) {
		self.init(
			red: (rgb >> 16) & 0xFF,
			green: (rgb >> 8) & 0xFF,
			blue: rgb & 0xFF
		)
	}
	
	func toVector() -> vector_float3 {
		return vector_float3(
			Float(cgColor.components?[0] ?? 0),
			Float(cgColor.components?[1] ?? 0),
			Float(cgColor.components?[2] ?? 0)
		)
	}
}
