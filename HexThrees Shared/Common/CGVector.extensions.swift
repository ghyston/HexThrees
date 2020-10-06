//
//  CGVector.extensions.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 11.06.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

extension CGVector {
	init(from: CGPoint, to: CGPoint) {
		self.init(dx: to.x - from.x, dy: to.y - from.y)
	}

	func squareLen() -> CGFloat {
		pow(self.dx, 2) + pow(self.dy, 2)
	}
	
	func invert() -> CGVector {
		CGVector(dx: -dx, dy: -dy)
	}
}
