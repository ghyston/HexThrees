//
//  HighlightableNode.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 07.10.19.
//  Copyright © 2019 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

protocol SelectableNode: SKNode {
	var selectorHex: SKShapeNode { get set }
	var selectorShadeHex: SKShapeNode { get set }
	
	// @todo: why I cant use private set in protocols?
	// @todo: how can I set default value in protocols?

	var canBeSelected: Bool { get set }
	func highlight()
	func shade() // @todo: rename to dim?
	func removeHighlight() // @todo: bad naming
}

extension SelectableNode where Self: HexNode {
	func createSelector() {
		
		guard let shaderManager: IShaderManager = ContainerConfig.instance.tryResolve() else {
			assert(true, "SelectableNode::createSelector failed to resolve shaderManager")
			return
		}
		
		self.selectorHex = SKShapeNode()
		self.selectorHex.path = self.hexShape.path
		self.selectorHex.fillColor = .clear
		self.selectorHex.lineWidth = 2
		self.selectorHex.strokeColor = .white
		self.selectorHex.zPosition = zPositions.selectorHexShape.rawValue
		self.selectorHex.strokeShader = shaderManager.selectableShader
		
		self.selectorShadeHex = SKShapeNode()
		self.selectorShadeHex.path = self.hexShape.path
		self.selectorShadeHex.zPosition = zPositions.selectorShadeShape.rawValue
		self.selectorShadeHex.fillShader = shaderManager.selectableShadeShader
		self.selectorShadeHex.lineWidth = 0
	}
	
	func highlight() {
		self.canBeSelected = true
		addChild(self.selectorHex)
	}
	
	func shade() {
		self.hexShape.addChild(self.selectorShadeHex)
	}
	
	func removeHighlight() {
		self.canBeSelected = false
		self.selectorHex.removeFromParentWithDelay(delay: GameConstants.CellAppearAnimationDuration)
		self.selectorShadeHex.removeFromParentWithDelay(delay: GameConstants.CellAppearAnimationDuration)
	}
}
