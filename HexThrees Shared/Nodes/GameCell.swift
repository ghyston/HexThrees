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
	
	var updateShader: AnimatedShader
	var updatePlayback: Playback?
	
	var value: Int
	var newParent: BgCell?
	let pal: IPaletteManager = ContainerConfig.instance.resolve()
	
	struct UniformNames {
		static let oldColor = "uOldColor"
		static let newColor = "uNewColor"
		static let startPoint = "uStart"
	}
	
	init(model: GameModel, val: Int) {
		self.value = val
		self.motionBlurDisabled = !model.motionBlurEnabled
		let strategyValue = model.strategy[self.value]
		
		// this is just to put placeholders
		self.hexShape = model.geometry.createHexCellShape()
		self.label = SKLabelNode()
		self.effectNode = SKEffectNode()
		self.blurFilter = CIFilter()
		self.prevPosition = CGPoint()
		
		// load shader and set default uniforms
		self.updateShader = AnimatedShader(fileNamed: "cellUpdateValue")
		self.updateShader.addUniform(
			name: UniformNames.oldColor,
			value: self.pal.color(value: 0).toVector())
		self.updateShader.addUniform(
			name: UniformNames.newColor,
			value: self.pal.color(value: 0).toVector())
		self.updateShader.addUniform(
			name: UniformNames.startPoint,
			value: vector_float2(0.0, 0.0))
		
		super.init()
		
		addBlur()
		addShape(shape: self.hexShape)
		addLabel(text: "\(strategyValue)")
		
		self.updateColor()
		
		// @todo: do I need to remove observer in destructor?
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
			self.updateShader.updateUniform(playbackValue)
		}
	}
	
	private class func startUpdateAnimatonPoint(by direction: SwipeDirection) -> vector_float2 {
		switch direction {
		case .Right: return vector_float2(0.0, 0.5)
		case .YDown: return vector_float2(0.0, 1.0)
		case .XDown: return vector_float2(1.0, 1.0)
		case .Left: return vector_float2(1.0, 0.5)
		case .YUp: return vector_float2(1.0, 0.0)
		case .XUp: return vector_float2(0.0, 0.0)
		case .Unknown: return vector_float2(0.0, 0.0)
		}
	}
	
	private func playUpdateAnimation(_ direction: SwipeDirection) {
		let startPoint = GameCell.startUpdateAnimatonPoint(by: direction)
		
		self.updateShader.updateUniform(
			name: UniformNames.oldColor,
			value: self.pal.color(value: self.value - 1).toVector())
		self.updateShader.updateUniform(
			name: UniformNames.newColor,
			value: self.pal.color(value: self.value).toVector())
		self.updateShader.updateUniform(
			name: UniformNames.startPoint,
			value: startPoint)
		
		self.updatePlayback = Playback()
		self.updatePlayback?.setRange(from: 0, to: 1.96)
		self.updatePlayback!.start(
			duration: GameConstants.SecondsPerCell * 1.4,
			reversed: false,
			repeated: false,
			onFinish: self.finishUpdate)
		
		self.hexShape.fillShader = self.updateShader
		
		let zoomIn = SKAction.scale(to: 1.3, duration: GameConstants.SecondsPerCell)
		zoomIn.timingMode = SKActionTimingMode.easeIn
		let zoomOut = SKAction.scale(to: 1.0, duration: GameConstants.SecondsPerCell)
		zoomOut.timingMode = SKActionTimingMode.easeIn
		self.run(SKAction.sequence([zoomIn, zoomOut]))
	}
	
	@objc private func finishUpdate() {
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
