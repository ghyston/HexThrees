//
//  BgCell.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 26.04.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

class BgCell: SKNode, HexNode, SelectableNode, BlockableNode, BonusableNode, UserBlockedNode, AnimatedNode {
	var playback: IPlayback?
	var hexShape: SKShapeNode
	
	var canBeSelected: Bool = false
	var selectorHex: SKShapeNode
	var selectorShadeHex: SKShapeNode
	var selectorPlayback: IPlayback?
	var selectorAppearPlayback: IPlayback?
	
	var isBlocked: Bool = false
	var isBlockedFromSwipe: Bool = false
	var userBlockedHex: SKShapeNode = SKShapeNode()
	var blockedPlayback: IPlayback?
	var blockedStaticShader: SKShader // @todo: make it lazy static (to init once per game)
	var circleTimerAnimatedShader: AnimatedShader // @todo: same?
	var blockingAnimatedShader: AnimatedShader
	var shape: SKShapeNode?
	var normalBgColor: vector_float3
	var blockedBgColor: vector_float3
	var blockLinesColor: vector_float3
	
	var gameCell: GameCell?
	var bonus: BonusNode?
	let coord: AxialCoord
	let pal: IPaletteManager = ContainerConfig.instance.resolve()
	
	init(hexShape: SKShapeNode, blocked: Bool, coord: AxialCoord) {
		self.isBlocked = blocked
		self.coord = coord
		
		// we need to set them to something in order to call super init
		// @todo: crap, just find a way to refactor this!!
		self.hexShape = SKShapeNode()
		self.selectorHex = SKShapeNode()
		self.selectorShadeHex = SKShapeNode()
		self.blockedStaticShader = SKShader()
		self.circleTimerAnimatedShader = AnimatedShader()
		self.blockingAnimatedShader = AnimatedShader()
		self.normalBgColor = vector_float3()
		self.blockedBgColor = vector_float3()
		self.blockLinesColor = vector_float3()
		
		super.init()
		
		self.addShape(shape: hexShape)
		self.createSelector()
		self.createUserBlockedHex()
		self.loadShader(
			shape: hexShape,
			palette: self.pal)
		
		if blocked {
			block()
		}
		
		updateColor(fillColor: self.pal.cellBgColor(), strokeColor: .white)
		
		// @todo: do I need to remove observer in destructor?
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(self.onColorChange),
			name: .switchPalette,
			object: nil)
	}
	
	@objc func onColorChange(notification: Notification) {
		updateColor(fillColor: self.pal.cellBgColor(), strokeColor: .white)
	}
	
	@objc func addGameCell(cell: GameCell) {
		assert(self.gameCell == nil, "BgCell already contain game cell")
		
		self.gameCell = cell
		self.addChild(cell)
		self.gameCell?.zPosition = zPositions.bgCellZ.rawValue
	}
	
	@objc func removeGameCell() {
		self.gameCell?.removeFromParent()
		self.gameCell = nil
	}
	
	@objc func removeShader() {
		self.shape?.fillShader = nil
		self.playback = nil
	}
	
	func destination(to: BgCell) -> CGVector {
		return CGVector(from: position, to: to.position)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func updateAnimation(_ delta: TimeInterval) {
		updateBlockableAnimation(delta)
		updateUserBlockedOutline(delta)
	}
}
