//
//  UserBlockedCell.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 07.05.19.
//  Copyright © 2019 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

protocol UserBlockedNode: class {
	var userBlockedHex: SKShapeNode { get set }
	var isBlockedFromSwipe: Bool { get set }
	var blockedPlayback: IPlayback? { get set }
	
	func blockFromSwipe()
	func unblockFromSwipe()
}

extension UserBlockedNode where Self: HexNode {
	func createUserBlockedHex() {
		self.userBlockedHex.path = self.hexShape.path
		self.userBlockedHex.strokeShader = SKShader(fileNamed: "blockSwipe")
		self.userBlockedHex.lineWidth = 0
		self.userBlockedHex.zPosition = zPositions.userBlockedHexShape.rawValue
	}
	
	func updateUserBlockedOutline(_ delta: TimeInterval) {
		if let playbackValue = self.blockedPlayback?.update(delta: delta) {
			self.userBlockedHex.lineWidth = CGFloat(playbackValue)
		}
	}
	
	func blockFromSwipe() {
		self.hexShape.addChild(self.userBlockedHex)
		self.isBlockedFromSwipe = true
		self.fadeIn()
	}
	
	func unblockFromSwipe() {
		self.isBlockedFromSwipe = false
		self.fadeOut()
	}
	
	private func fadeIn() {
		self.blockedPlayback = Playback(
			from: 0,
			to: 3.0,
			duration: GameConstants.CellAppearAnimationDuration,
			onFinish: self.removePlayback)
	}
	
	private func fadeOut() {
		self.blockedPlayback = Playback(
			from: 3.0,
			to: 0.0,
			duration: GameConstants.CellAppearAnimationDuration,
			onFinish: self.removePlaybackWithNode)
	}
	
	private func removePlaybackWithNode() {
		self.removePlayback()
		self.userBlockedHex.removeFromParent()
	}
	
	private func removePlayback() {
		self.blockedPlayback = nil
	}
}
