//
//  SKNode.extensions.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 10.12.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

extension SKNode {
	func runForAllSubnodes(lambda: (_: SKNode) -> Void) {
		lambda(self)
		for child in self.children {
			child.runForAllSubnodes(lambda: lambda)
		}
	}
	
	func removeFromParentWithDelay(delay: Double) {
		let delay = SKAction.wait(forDuration: delay)
		let delete = SKAction.perform(#selector(SKNode.removeFromParent), onTarget: self)
		self.parent?.run(SKAction.sequence([delay, delete]))
	}
	
	func playAppearAnimation(duration: TimeInterval = GameConstants.CellAppearAnimationDuration, delay: TimeInterval? = nil) {
		self.setScale(0.01)
		let scaleAction = SKAction.scale(to: 1.0, duration: duration)
		scaleAction.timingMode = .easeInEaseOut
		
		guard let delayVal = delay else {
			self.run(scaleAction)
			return
		}
		
		let delayAction = SKAction.wait(forDuration: delayVal)
		self.run(SKAction.sequence([delayAction, scaleAction]))
	}
    
    func playDisappearAnimation(duration: TimeInterval = GameConstants.CellAppearAnimationDuration, delay: TimeInterval? = nil) {
        
        let scaleAction = SKAction.scale(to: 0.01, duration: duration)
        scaleAction.timingMode = .easeInEaseOut
        
        guard let delayVal = delay else {
            self.run(scaleAction)
            return
        }
        
        let delayAction = SKAction.wait(forDuration: delayVal)
        self.run(SKAction.sequence([delayAction, scaleAction]))
    }
}

extension SKAction {
	func with(mode: SKActionTimingMode) -> SKAction {
		self.timingMode = mode
		return self
	}
}
