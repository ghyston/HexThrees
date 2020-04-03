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
	var selectorPlayback : IPlayback? { get set }
	
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
	}
	
    func highlight() {
        self.canBeSelected = true
		
		self.selectorPlayback = Playback()
		self.selectorPlayback?.setRange(from: 0, to: 1.0)
        self.selectorPlayback!.start(
			duration: 1.0,
            reversed: false,
            repeated: true,
            onFinish: nil)
		
		addChild(self.selectorHex)
    }
    
    func shade() {
        //@todo
    }
	
	func updateSelectableAnimation(_ delta: TimeInterval) {
        if let playbackValue = self.selectorPlayback?.update(delta: delta) {
			if let shader = self.selectorHex.strokeShader as? AnimatedShader {
                shader.update(playbackValue)
            }
        }
    }
    
    func removeHighlight() {
        self.canBeSelected = false
		self.selectorHex.removeFromParent()
		self.selectorPlayback = nil
    }
}
