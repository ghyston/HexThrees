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
}

extension SKAction {
	func with(mode: SKActionTimingMode) -> SKAction {
		self.timingMode = mode
		return self
	}
}
