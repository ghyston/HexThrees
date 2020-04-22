//
//  CollectableBtn.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 16.09.19.
//  Copyright © 2019 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

class CollectableBtn: SKNode, AnimatedNode {
	private var playback: IPlayback?
	
	let sprite: SKSpriteNode
	let type: BonusType
	var updated: Bool = false // this flag shows that btn has not been updated at all
	lazy var gameModel: GameModel = ContainerConfig.instance.resolve()
	
	init(type: BonusType) {
		self.type = type
		let spriteName = BonusFabric.spriteName(bonus: type)
		self.sprite = SKSpriteNode(imageNamed: spriteName)
		
		if let shaderManager: IShaderManager = ContainerConfig.instance.tryResolve() {
			self.sprite.shader = shaderManager.collectableButtonShader
		}	
		
		super.init()
		addChild(self.sprite)
	}
	
	func updateAnimation(_ delta: TimeInterval) {
		if let playbackValue = self.playback?.update(delta: delta) {
			self.sprite.setValue(SKAttributeValue(float: Float(playbackValue)), forAttribute: "aPos")
		}
	}
	
	func onCollectableUpdate(notification: Notification) {
		if notification.object as? BonusType != self.type {
			return
		}
		
		guard let collectable = self.gameModel.collectableBonuses[self.type] else {
			return
		}
		
		let step = 1.0 / Double(collectable.maxValue)
		let start = updated ? Double(collectable.currentValue - 1) * step : 0.0
		
		let isFullScale: CGFloat = 1.2
		let updateAnimationScale: CGFloat = 1.3
		let normalScale: CGFloat = 1.0
		
		self.playback = Playback(
			from: start,
			to: start + step,
			duration: GameConstants.CollectableUpdateAnimationDuration,
			onFinish: self.removeAnimation)
		
		if updated {
			let zoomIn = SKAction.scale(to: updateAnimationScale, duration: GameConstants.SecondsPerCell)
			zoomIn.timingMode = SKActionTimingMode.easeOut
			let zoomOut = SKAction.scale(to: collectable.isFull ? isFullScale : normalScale, duration: GameConstants.SecondsPerCell)
			zoomOut.timingMode = SKActionTimingMode.easeIn
			self.run(SKAction.sequence([zoomIn, zoomOut]))
		}
		else if collectable.isFull {
			self.run(SKAction.scale(to: isFullScale, duration: GameConstants.SecondsPerCell))
		}
		
		updated = true
	}
	
	func playUseAnimation() {
		guard let collectable = self.gameModel.collectableBonuses[self.type] else {
			return
		}
		
		self.playback = Playback(
			from: Double(collectable.maxValue),
			to: 0.0,
			duration: GameConstants.CollectableUpdateAnimationDuration,
			onFinish: self.removeAnimation)
	}
	
	@objc private func removeAnimation() {
		self.playback = nil
	}
	
	func onClick() {
		
		// Second click
		if self.gameModel.selectedBonusType == self.type {
			self.gameModel.selectCMD = nil
			self.gameModel.selectedBonusType = nil
			EndCellSelectionCMD(self.gameModel).run()
			return
		}
		// Other button already clicked
		else if (self.gameModel.selectedBonusType != nil) {
			return
		}
		
		// First click
		if self.gameModel.collectableBonuses[self.type]?.isFull == true {
			if let collectableBonus = BonusFabric.collectableSelectableBonusCMD(bonus: self.type, gameModel: self.gameModel) {
				self.gameModel.selectedBonusType = self.type
				StartCellSelectionCMD(self.gameModel)
					.run(
						comparator: collectableBonus.comparator,
						onSelectCmd: collectableBonus.cmd)
			} else if let bonusCmd = BonusFabric.collectableNotSelectableBonusCMD(bonus: self.type, gameModel: self.gameModel) {
				bonusCmd.run()
				self.gameModel.collectableBonuses[self.type]?.use()
				NotificationCenter.default.post(name: .useCollectables, object: self.type)
			}
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
