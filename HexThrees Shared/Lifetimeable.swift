//
//  Lifetimeable.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 08.05.20.
//  Copyright © 2020 Ilja Stepanow. All rights reserved.
//

import Foundation

// this protocol is constrained to class, because this way self is mutable. Details: https://stackoverflow.com/a/32489442/1741428
protocol LifeTimeable : class {
	var lifetime: Int { get set } //@todo: internal set?
	func incLifetime()
	func isOlderThan(val: Int) -> Bool
	func isOld() -> Bool
}

extension LifeTimeable {
	func incLifetime() {
		self.lifetime = lifetime + 1
	}
	
	func isOlderThan(val: Int) -> Bool {
		lifetime > val
	}
	
	func isOld() -> Bool {
		isOlderThan(val: 1)
	}
}
