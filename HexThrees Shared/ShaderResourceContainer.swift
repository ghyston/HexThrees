//
//  ShaderResourceContainer.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 21.04.20.
//  Copyright © 2020 Ilja Stepanow. All rights reserved.
//

import Foundation

class ShaderResourceContainer {
	
	private let 🏭: () -> AnimatedShader
	private var unused = [AnimatedShader]()
	
	init(shaderFactoryMethod: @escaping () -> AnimatedShader) {
		self.🏭 = shaderFactoryMethod
	}
	
	func getFree() -> AnimatedShader {
		unused.popLast() ?? 🏭()
	}
	
	func putBack(_ shader: AnimatedShader) {
		unused.append(shader)
	}
}
