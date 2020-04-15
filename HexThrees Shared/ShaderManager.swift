//
//  ShaderManager.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 14.04.20.
//  Copyright © 2020 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

protocol IShaderManager {
	var selectableShader: AnimatedShader { get set }
	var selectableShadeShader: AnimatedShader { get set }
	
	func updateSelectableAnimation(_ delta: TimeInterval)
	func fadeInSelectable()
	func fadeOutSelectable()
}

class ShaderManager: IShaderManager {
	lazy var selectableShader = ShaderManager.loadSelectable()
	lazy var selectableShadeShader = ShaderManager.loadSelectableShade()
	
	private var selectorIdlePlayback: IPlayback?
	private var selectorAppearPlayback: IPlayback?
	private var selectorDisappearPlayback: IPlayback?
	
	func fadeInSelectable() {
		self.createFadeInPlayback()
		self.createIdlePlayback()
	}
	
	func fadeOutSelectable() {
		self.createFadeOutPlayback()
	}
	
	private class func loadSelectable() -> AnimatedShader {
		let shader = AnimatedShader(fileNamed: "selectable")
		shader.addUniform(name: "u_appear", value: 0.0)
		return shader
	}
	
	private class func loadSelectableShade() -> AnimatedShader {
		let shader = AnimatedShader(fileNamed: "selectableShade")
		shader.updateUniform(1.0)
		return shader
	}
	
	private func createIdlePlayback() {
		self.selectorIdlePlayback = Playback()
		self.selectorIdlePlayback?.setRange(from: 0, to: 1.0)
		self.selectorIdlePlayback?.start(
			duration: 1.0,
			reversed: false,
			repeated: true,
			onFinish: nil)
	}
	
	private func createFadeInPlayback() {
		self.selectorAppearPlayback = Playback()
		self.selectorAppearPlayback?.setRange(from: 0, to: 1.0)
		self.selectorAppearPlayback?.start(
			duration: GameConstants.CellAppearAnimationDuration,
			reversed: false,
			repeated: false,
			onFinish: {
				self.selectorAppearPlayback = nil
			})
	}
	
	private func createFadeOutPlayback() {
		self.selectorDisappearPlayback = Playback()
		self.selectorDisappearPlayback?.setRange(from: 1.0, to: 0.0)
		self.selectorDisappearPlayback?.start(
			duration: GameConstants.CellAppearAnimationDuration,
			reversed: false,
			repeated: false,
			onFinish: {
				self.selectorIdlePlayback = nil
				self.selectorDisappearPlayback = nil
			})
	}
	
	func updateSelectableAnimation(_ delta: TimeInterval) {
		if let idlePlaybackValue = self.selectorIdlePlayback?.update(delta: delta) {
			self.selectableShader.updateUniform(idlePlaybackValue)
		}
		
		if let appearPlaybackValue = self.selectorAppearPlayback?.update(delta: delta) {
			self.selectableShader.updateUniform(appearPlaybackValue, variableName: "u_appear")
			self.selectableShadeShader.updateUniform(appearPlaybackValue)
		}
		
		if let dissapearPlaybackValue = self.selectorDisappearPlayback?.update(delta: delta) {
			self.selectableShader.updateUniform(dissapearPlaybackValue, variableName: "u_appear")
			self.selectableShadeShader.updateUniform(dissapearPlaybackValue)
		}
	}
}
