//
//  Random.extensions.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 07.06.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//  copied from: https://stackoverflow.com/questions/25050309/swift-random-float-between-0-and-1

import CoreGraphics
import Foundation

public extension Double {
	/// Returns a random floating point number between 0.0 and 1.0, inclusive.
	static var random: Double {
		Double.random(in: 0 ... 1)
	}
}

public extension Float {
	/// Returns a random floating point number between 0.0 and 1.0, inclusive.
	static var random: Float {
		Float.random(in: 0 ... 1)
	}
}

public extension CGFloat {
	/// Randomly returns either 1.0 or -1.0.
	static var randomSign: CGFloat {
		(arc4random_uniform(2) == 0) ? 1.0 : -1.0
	}

	/// Returns a random floating point number between 0.0 and 1.0, inclusive.
	static var random: CGFloat {
		CGFloat.random(in: 0 ... 1)
	}
}
