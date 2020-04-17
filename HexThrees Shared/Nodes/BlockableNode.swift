//
//  BlockableNode.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 04.12.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

protocol AnimatedNode {
	func updateAnimation(_ delta: TimeInterval)
}

protocol BlockableNode: class {
	var isBlocked: Bool { get set }
	var blockablePlayback: IPlayback? { get set }
	
	func updateBlockableAnimation(_ delta: TimeInterval)
	func removeShader()
	func block()
	func unblock()
}

// This extension is handle both animations for blocking cell and for circle timer
extension BlockableNode where Self: HexNode, Self: SKNode {
	
	private func GetShaderManager() -> IShaderManager? {
		ContainerConfig.instance.tryResolve()
	}
	
	func playCircleAnimation() {
		self.removeRollbackDelayedAction()
		self.blockablePlayback = Playback(
			from: 0,
			to: .pi * 2.0,
			duration: GameConstants.StressTimerInterval,
			onFinish: self.removeShaderWithDelay)
		
		self.hexShape.fillShader = GetShaderManager()?.circleShader
	}
	
	func playRollbackCircleAnimation() {
		self.blockablePlayback?.rollback(
			duration: GameConstants.StressTimerRollbackInterval,
			onFinish: self.removeShaderWithDelay)
	}
	
	func updateBlockableAnimation(_ delta: TimeInterval) {
		if let playbackValue = self.blockablePlayback?.update(delta: delta) {
			// this should cover blocking shader as well as circle shader, I guess
			self.hexShape.setValue(SKAttributeValue(float: Float(playbackValue)), forAttribute: "aPos")
		}
	}
	
	func block() {
		self.removeRollbackDelayedAction()
		
		self.blockablePlayback = Playback(
			duration: GameConstants.BlockAnimationDuration,
			onFinish: self.setStaticBlockShader)
		self.hexShape.fillShader = GetShaderManager()?.blockingAnimatedShader
		
		self.isBlocked = true
	}
	
	func unblock() {
		self.blockablePlayback = Playback(
			duration: GameConstants.BlockAnimationDuration,
			reversed: true,
			onFinish: self.removeShader)
		self.hexShape.fillShader = GetShaderManager()?.blockingAnimatedShader
		
		self.isBlocked = false
	}
	
	// After stress timer do not remove shader immidiately, wait until new cell is apeared.
	private func removeShaderWithDelay() {
		let delayHide = SKAction.wait(forDuration: GameConstants.CellAppearAnimationDuration)
		let removeShader = SKAction.perform(#selector(BgCell.removeShader), onTarget: self)
		self.run(SKAction.sequence([delayHide, removeShader]), withKey: self.RollbackActionKey())
	}
	
	private func setStaticBlockShader() {
		self.hexShape.fillShader = GetShaderManager()?.blockedStaticShader
		self.blockablePlayback = nil
	}
	
	private func removeRollbackDelayedAction() {
		self.removeAction(forKey: self.RollbackActionKey())
	}
	
	private func RollbackActionKey() -> String {
		"rollback_action"
	}
}
