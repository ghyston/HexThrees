//
//  AnimatedShaderNode.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 15.06.19.
//  Copyright © 2019 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

extension SKShader {
	func addUniform(name: String, value: Float) {
		addUniform(SKUniform(name: name, float: value))
	}
	
	func addUniform(name: String, value: vector_float3) {
		addUniform(SKUniform(name: name, vectorFloat3: value))
	}
	
	func addUniform(name: String, value: vector_float2) {
		addUniform(SKUniform(name: name, vectorFloat2: value))
	}
	
	func updateUniform(name: String, value: Float) {
		uniformNamed(name)?.floatValue = value
	}
	
	func updateUniform(name: String, value: vector_float3) {
		uniformNamed(name)?.vectorFloat3Value = value
	}
	
	func updateUniform(name: String, value: vector_float2) {
		uniformNamed(name)?.vectorFloat2Value = value
	}
}

class AnimatedShader: SKShader {
	convenience init(fileNamed: String) {
		guard let fileURL = Bundle.main.url(forResource: fileNamed, withExtension: "fsh") else {
			assert(true, "file \(fileNamed) not found")
			self.init()
			return
		}
		
		do {
			let shaderSource = try String(contentsOf: fileURL, encoding: .utf8)
			self.init(
				source: shaderSource,
				uniforms: [SKUniform(name: "uPos", float: 0.0)])
			return
		} catch {
			self.init()
			assert(true, "load shader file failed: \(error)")
		}
	}
	
	func updateUniform(_ value: Float, variableName: String) {
		let uPos = uniformNamed(variableName)
		uPos?.floatValue = value
	}
	
	func updateUniform(_ value: Double, variableName: String) {
		updateUniform(Float(value), variableName: variableName)
	}
	
	func updateUniform(_ floatUPos: Float) {
		let uPos = uniformNamed("uPos")
		uPos?.floatValue = floatUPos
	}
	
	func updateUniform(_ doubleUPos: Double) {
		updateUniform(Float(doubleUPos))
	}
}
