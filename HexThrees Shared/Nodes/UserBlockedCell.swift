//
//  UserBlockedCell.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 07.05.19.
//  Copyright © 2019 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

protocol UserBlockedNode : class {
	
	var isBlockedFromSwipe: Bool { get set }
	
	func blockFromSwipe()
	func unblockFromSwipe()
}

extension UserBlockedNode where Self : HexNode {
	
	func blockFromSwipe() {
		
		let shader = SKShader.init(fileNamed: "blockSwipe")
		self.hexShape.lineWidth = 20
		self.hexShape.strokeShader = shader
		self.isBlockedFromSwipe = true
	}
	
	func unblockFromSwipe() {
		self.hexShape.strokeShader = nil
		self.isBlockedFromSwipe = false
		self.hexShape.lineWidth = 0
	}
}
