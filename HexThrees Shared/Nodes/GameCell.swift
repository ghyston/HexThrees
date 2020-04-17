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
	
	struct AttributeNames {
		static let oldColor = "aOldColor"
		static let newColor = "aNewColor"
		static let startPoint = "aStart"
		static let progress = "aPos"
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
			self.hexShape.setValue(
				SKAttributeValue(float: Float(playbackValue)),
				forAttribute: AttributeNames.progress)
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
		
		self.hexShape.setValue(
			SKAttributeValue(vectorFloat3: self.pal.color(value: self.value - 1).toVector()),
			forAttribute: AttributeNames.oldColor)
		
		self.hexShape.setValue(
			SKAttributeValue(vectorFloat3: self.pal.color(value: self.value).toVector()),
			forAttribute: AttributeNames.newColor)
		
		self.hexShape.setValue(
			SKAttributeValue(vectorFloat2: startPoint),
			forAttribute: AttributeNames.startPoint)
		
		self.updatePlayback = Playback(
			from: 0,
			to: 1.96,
			duration: GameConstants.SecondsPerCell * 2.5,
			onFinish: self.finishUpdate)
		
		let shaderManager: IShaderManager = ContainerConfig.instance.resolve()
		self.hexShape.fillShader = shaderManager.cellUpdateShader
		
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
