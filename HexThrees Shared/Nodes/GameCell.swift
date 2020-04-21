//
//  GameCell.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 26.04.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

class GameCell: SKNode, HexNode, LabeledNode, MotionBlurNode, AnimatedNode {
	var prevPosition: CGPoint?
	var prevDelta: Double?
	
	var hexShape: SKShapeNode
	var label: SKLabelNode
	
	var effectNode: SKEffectNode
	var blurFilter: CIFilter
	var motionBlurDisabled: Bool
	
	var updatePlayback: Playback?
	
	var value: Int
	var newParent: BgCell?
	let pal: IPaletteManager = ContainerConfig.instance.resolve()
	
	struct UniformNames {
		static let oldColor = "uOldColor"
		static let newColor = "uNewColor"
		static let startPoint = "uStart"
		static let progress = "uPos"
	}
	
	init(model: GameModel, val: Int) {
		self.value = val
		self.motionBlurDisabled = !model.motionBlurEnabled
		let strategyValue = model.strategy[self.value]
		self.hexShape = model.geometry.createHexCellShape()
		
		// this is just to put placeholders
		self.label = SKLabelNode()
		self.effectNode = SKEffectNode()
		self.blurFilter = CIFilter()
		self.prevPosition = CGPoint()
		
		super.init()
		
		addBlur()
		addShape(shape: self.hexShape)
		addLabel(text: "\(strategyValue)")
		
		self.updateColor()
		
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(self.onColorChange),
			name: .switchPalette,
			object: nil)
		
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(self.onMotionBlurSettingsChange),
			name: .switchMotionBlur,
			object: nil)
	}
	
	@objc func onColorChange(notification: Notification) {
		self.updateColor()
	}
	
	@objc func onMotionBlurSettingsChange(notification: Notification) {
		guard let isOn = notification.object as? Bool else {
			return
		}
		
		isOn ? enableBlur() : disableBlur()
	}
	
	func updateColor() {
		self.updateColor(fontColor: .white)
		self.updateColor(fillColor: self.pal.color(value: self.value), strokeColor: .white)
	}
	
	func updateColorForTutorial() {
		self.updateColor(fontColor: .white)
		self.updateColor(fillColor: self.pal.cellTutorialColor(), strokeColor: .white)
	}
	
	func playAppearAnimation() {
		self.setScale(0.01)
		self.run(SKAction.scale(to: 1.0, duration: GameConstants.CellAppearAnimationDuration))
	}
	
	func updateAnimation(_ delta: TimeInterval) {
		if let playbackValue = self.updatePlayback?.update(delta: delta) {
			if let shader: AnimatedShader = self.hexShape.fillShader as? AnimatedShader {
				shader.updateUniform(playbackValue)
			}
		}
	}
	
	private class func startUpdateAnimatonPoint(by direction: SwipeDirection) -> vector_float2 {
		let magic: Float = 0.9325; //because anle is not 45°, but 60° it is not 1.0. Calculations on page 129.
		switch direction {
		case .Right: return vector_float2(0.0, 0.5)
		case .YDown: return vector_float2(0.25, magic)
		case .XDown: return vector_float2(0.75, magic)
		case .Left: return vector_float2(1.0, 0.5)
		case .YUp: return vector_float2(0.75, 0.0675)
		case .XUp: return vector_float2(0.25, 0.0675)
		case .Unknown: return vector_float2(0.0, 0.0)
		}
	}
	
	private func playUpdateAnimation(_ direction: SwipeDirection) {
		let startPoint = GameCell.startUpdateAnimatonPoint(by: direction)
		
		let shaderManager: IShaderManager = ContainerConfig.instance.resolve()
		let shader = shaderManager.cellUpdateShadersContainer.getFree()
		
		shader.updateUniform(
			name: UniformNames.oldColor,
			value: self.pal.color(value: self.value - 1).toVector())
		shader.updateUniform(
			name: UniformNames.newColor,
			value: self.pal.color(value: self.value).toVector())
		shader.updateUniform(
			name: UniformNames.startPoint,
			value: startPoint)
		
		self.hexShape.fillShader = shader
		
		self.updatePlayback = Playback(
			from: 0,
			to: 1.96,
			duration: GameConstants.SecondsPerCell * 2.5,
			onFinish: self.finishUpdate)
		
		let zoomIn = SKAction.scale(to: 1.3, duration: GameConstants.SecondsPerCell)
		zoomIn.timingMode = SKActionTimingMode.easeIn
		let zoomOut = SKAction.scale(to: 1.0, duration: GameConstants.SecondsPerCell)
		zoomOut.timingMode = SKActionTimingMode.easeIn
		self.run(SKAction.sequence([zoomIn, zoomOut]))
	}
	
	@objc private func finishUpdate() {
		if let shader: AnimatedShader = self.hexShape.fillShader as? AnimatedShader {
			let shaderManager: IShaderManager = ContainerConfig.instance.resolve()
			shaderManager.cellUpdateShadersContainer.putBack(shader)
		}
		
		self.hexShape.fillShader = nil
		self.updatePlayback = nil
	}
	
	func playMoveAnimation(diff: CGVector, duration: Double) {
		let moveAnimation = SKAction.move(by: diff, duration: duration)
		moveAnimation.timingMode = SKActionTimingMode.easeIn
		self.run(moveAnimation)
		
		// @todo: move this to MotionBlurNode ?
		self.startBlur()
		let delayStopBlur = SKAction.wait(forDuration: duration)
		let delete = SKAction.perform(#selector(GameCell.stopBlurDelayed), onTarget: self)
		self.run(SKAction.sequence([delayStopBlur, delete]))
	}
	
	@objc func stopBlurDelayed() {
		self.stopBlur()
	}
	
	func updateValue(value: Int, strategy: MergingStrategy, direction: SwipeDirection? = nil) {
		self.value = value
		let strategyValue = strategy[self.value]
		self.updateText(text: "\(strategyValue)")
		if let from = direction {
			self.playUpdateAnimation(from)
		}
		self.updateColor()
	}
	
	// @todo: this is a big dirty hack
	override func addChild(_ node: SKNode) {
		if self.effectNode.parent != nil {
			self.effectNode.addChild(node)
		} else {
			super.addChild(node)
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
