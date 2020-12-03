//
//  SKShapeNode.extensions.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 21.04.20.
//  Copyright © 2020 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

extension SKShapeNode {
	
	// Because SKShapeNode setValue(Attribute) is broken and does not work with shaders, it is possible to use this code to transfer values into fragment shader wo recompilation and using same shader for several nodes.
	// In fragment shader: `vec4 color = SKDefaultShading(); float value = color.r * (1.0 / color.g);`
	// Unfortunatelly, it works only with one float, for transfering colors ing GameCell I used one shader per node. THIS DOES NOT SCALE WELL 😥
	func setColorAsAttribute(value: CGFloat, maxValue: CGFloat) {
		let backScale = 1.0 / maxValue;
		let valueNormalized = value / maxValue
		self.fillColor = SKColor(red: valueNormalized, green: backScale, blue: 0.0, alpha: 1.0)
	}
}
