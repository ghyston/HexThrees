//
//  SwipeDirections.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 13.06.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

enum SwipeDirection: CaseIterable {
	case
		Unknown,
		XUp,
		XDown,
		YUp,
		YDown,
		Left,
		Right

	func inverse() -> SwipeDirection {
		switch self {
			case .XUp:
				return .XDown
			case .XDown:
				return .XUp
			case .YUp:
				return .YDown
			case .YDown:
				return .YUp
			case .Left:
				return .Right
			case .Right:
				return .Left
			default:
				return .Unknown
		}
	}
	
	func angle() -> Double {
		switch self {
			case .XUp:
				return .pi / 3.0
			case .XDown:
				return .pi * (4.0 / 3.0)
			case .YUp:
				return .pi * (2.0 / 3.0)
			case .YDown:
				return .pi * (5.0 / 3.0)
			case .Left:
				return .pi
			case .Right:
				return 0.0
			default:
				return 0.0
		}
	}
}
