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
	var selectableHighlightShader: AnimatedShader { get }
	var selectableMuffleShader: AnimatedShader { get }
	
	var collectableButtonShader: AnimatedShader { get }
	
	var blockedStaticShader: SKShader { get }
	var blockingAnimatedShader: AnimatedShader { get }
	var circleShader: AnimatedShader { get }
	
	func updateSelectableAnimation(_ delta: TimeInterval)
	func fadeInSelectable()
	func fadeOutSelectable()
	
	func onPaletteUpdate()
}

class ShaderManager: IShaderManager {
	let selectableHighlightShader: AnimatedShader = {
		let shader = AnimatedShader(fileNamed: "selectableHighlight")
		shader.addUniform(name: "u_appear", value: 0.0)
		return shader
	}()
	
	let selectableMuffleShader: AnimatedShader = {
		let shader = AnimatedShader(fileNamed: "selectableMuffle")
		shader.updateUniform(1.0)
		return shader
	}()
	
	let collectableButtonShader: AnimatedShader = {
		let shader = AnimatedShader(fileNamed: "collectableButton")
		shader.attributes = [SKAttribute(name: "aPos", type: .float)]
		return shader
	}()
	
	var blockedStaticShader: SKShader = {
		let shader = SKShader(fileNamed: "blockStatic2")
		
		shader.addUniform(
			name: "uBlockedColor",
			value: vector_float3())
		
		shader.addUniform(
			name: "uBlockedLineColor",
			value: vector_float3())
		
		return shader
	}()
	
	var blockingAnimatedShader: AnimatedShader = {
		let shader = AnimatedShader(fileNamed: "blockAnimated2")
		
		shader.addUniform(
			name: "uBgColor",
			value: vector_float3())
		
		shader.addUniform(
			name: "uBlockedColor",
			value: vector_float3())
		
		shader.addUniform(
			name: "uBlockedLineColor",
			value: vector_float3())
		
		shader.attributes = [SKAttribute(name: "aPos", type: .float)]
		
		return shader
	}()
	
	var circleShader: AnimatedShader  = {
		   let shader = AnimatedShader(fileNamed: "circleTimer")
		   
		   shader.addUniform(
			   name: "uBgColor",
			   value: vector_float3())
		   
		   shader.addUniform(
			   name: "uBlockedColor",
			   value: vector_float3())
		
		shader.attributes = [SKAttribute(name: "aPos", type: .float)]
		
			return shader
	   }()
	
	private var selectorIdlePlayback: IPlayback?
	private var selectorAppearPlayback: IPlayback?
	private var selectorDisappearPlayback: IPlayback?
	
	func onPaletteUpdate() {
		guard let palette: IPaletteManager = ContainerConfig.instance.tryResolve() else {
			assert(true, "ShaderManager::onPaletteUpdate Palette failed to resolve")
			return
		}
		
		let normalBgColor = palette.cellBgColor().toVector()
		let blockedBgColor = palette.cellBlockedBgColor().toVector()
		let blockLinesColor = palette.cellBlockingLinesColor().toVector()
		
		self.blockedStaticShader.updateUniform(
			name: "uBlockedColor",
			value: blockedBgColor)
		
		self.blockedStaticShader.updateUniform(
			name: "uBlockedLineColor",
			value: blockLinesColor)
		
		self.blockingAnimatedShader.updateUniform(
			name: "uBgColor",
			value: normalBgColor)
		
		self.blockingAnimatedShader.updateUniform(
			name: "uBlockedColor",
			value: blockedBgColor)
		
		self.blockingAnimatedShader.updateUniform(
			name: "uBlockedLineColor",
			value: blockLinesColor)
		
		self.circleShader.updateUniform(
			name: "uBgColor",
			value: normalBgColor)
		
		self.circleShader.updateUniform(
			name: "uBlockedColor",
			value: blockedBgColor)
	}
	
	func fadeInSelectable() {
		self.createFadeInPlayback()
		self.createIdlePlayback()
	}
	
	func fadeOutSelectable() {
		self.createFadeOutPlayback()
	}
	
	private func createIdlePlayback() {
		self.selectorIdlePlayback = Playback(
			duration: 1.0,
			repeated: true)
	}
	
	private func createFadeInPlayback() {
		self.selectorAppearPlayback = Playback(
			duration: GameConstants.CellAppearAnimationDuration,
			onFinish: {
				self.selectorAppearPlayback = nil
			})
	}
	
	private func createFadeOutPlayback() {
		self.selectorDisappearPlayback = Playback(
			duration: GameConstants.CellAppearAnimationDuration,
			reversed: true,
			onFinish: {
				self.selectorIdlePlayback = nil
				self.selectorDisappearPlayback = nil
			})
	}
	
	func updateSelectableAnimation(_ delta: TimeInterval) {
		if let idlePlaybackValue = self.selectorIdlePlayback?.update(delta: delta) {
			self.selectableHighlightShader.updateUniform(idlePlaybackValue)
		}
		
		if let appearPlaybackValue = self.selectorAppearPlayback?.update(delta: delta) {
			self.selectableHighlightShader.updateUniform(appearPlaybackValue, variableName: "u_appear")
			self.selectableMuffleShader.updateUniform(appearPlaybackValue)
		}
		
		if let dissapearPlaybackValue = self.selectorDisappearPlayback?.update(delta: delta) {
			self.selectableHighlightShader.updateUniform(dissapearPlaybackValue, variableName: "u_appear")
			self.selectableMuffleShader.updateUniform(dissapearPlaybackValue)
		}
	}
}
