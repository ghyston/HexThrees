//
//  HighlightableNode.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 07.10.19.
//  Copyright © 2019 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

protocol SelectableNode : SKNode {
    
	var selectorHex : SKShapeNode { get set }
	var selectorShadeHex : SKShapeNode { get set }
	var selectorPlayback : IPlayback? { get set }
	var selectorAppearPlayback : IPlayback? { get set }
	
    // @todo: why I cant use private set in protocols?
    // @todo: how can I set default value in protocols?
	func updateSelectableAnimation(_ delta: TimeInterval)
    var canBeSelected : Bool { get set }
    func highlight()
    func shade() //@todo: rename to dim?
    func removeHighlight() //@todo: bad naming
}

extension SelectableNode where Self : HexNode {
    
	func createSelector() {
		self.selectorHex = SKShapeNode()
		self.selectorHex.path = self.hexShape.path
		self.selectorHex.fillColor = .clear
		self.selectorHex.lineWidth = 2
		self.selectorHex.strokeColor = .white
		self.selectorHex.zPosition = zPositions.selectorHexShape.rawValue
		//@todo: can one shader be used in many places? If so, create shader manager for reusable shaders
		self.selectorHex.strokeShader = AnimatedShader.init(fileNamed: "selectable")
		self.selectorHex.strokeShader?.addUniform(name: "u_appear", value: 0.0)
		
		self.selectorShadeHex = SKShapeNode()
		self.selectorShadeHex.path = self.hexShape.path
		self.selectorShadeHex.zPosition = zPositions.selectorShadeShape.rawValue
		self.selectorShadeHex.fillShader = AnimatedShader.init(fileNamed: "selectableShade")
		(self.selectorShadeHex.fillShader as? AnimatedShader)?.update(1.0)
		self.selectorShadeHex.lineWidth = 0
	}
	
    func highlight() {
        self.canBeSelected = true
		
		createIdlePlayback()
		createFadeInPlayback()
		
		addChild(self.selectorHex)
    }
    
    func shade() {
		self.hexShape.addChild(self.selectorShadeHex)
		createFadeInPlayback()
    }
	
	func updateSelectableAnimation(_ delta: TimeInterval) {
        if let playbackValue = self.selectorPlayback?.update(delta: delta) {
			(self.selectorHex.strokeShader as? AnimatedShader)?.update(playbackValue)
        }
		
		if let appearPlaybackValue = self.selectorAppearPlayback?.update(delta: delta) {
			(self.selectorHex.strokeShader as? AnimatedShader)?.update(appearPlaybackValue, variableName: "u_appear")
			(self.selectorShadeHex.fillShader as? AnimatedShader)?.update(appearPlaybackValue)
		}
    }
    
    func removeHighlight() {
        self.canBeSelected = false
		createFadeOutPlayback()
    }
	
	private func createIdlePlayback() {
		self.selectorPlayback = Playback()
		self.selectorPlayback?.setRange(from: 0, to: 1.0)
        self.selectorPlayback!.start(
			duration: 1.0,
            reversed: false,
            repeated: true,
            onFinish: nil)
	}
	
	private func createFadeInPlayback() {
		self.selectorAppearPlayback = Playback()
		self.selectorAppearPlayback?.setRange(from: 0, to: 1.0)
        self.selectorAppearPlayback!.start(
			duration: GameConstants.CellAppearAnimationDuration,
            reversed: false,
            repeated: false,
            onFinish: removeAppearPlayback)
	}
	
	private func createFadeOutPlayback() {
		self.selectorAppearPlayback = Playback()
		self.selectorAppearPlayback?.setRange(from: 1.0, to: 0.0)
        self.selectorAppearPlayback!.start(
			duration: GameConstants.CellAppearAnimationDuration,
            reversed: false,
            repeated: false,
            onFinish: removeHightlightDelayed)
	}
	
	private func removeAppearPlayback() {
		self.selectorAppearPlayback = nil
	}
	
	private func removeHightlightDelayed() {
		self.selectorPlayback = nil
		removeAppearPlayback()
		self.selectorHex.removeFromParent()
		self.selectorShadeHex.removeFromParent()
    }
}
