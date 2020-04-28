//
//  ProbabilityDice.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 30.08.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class ProbabilityArray<T> {
	struct PossibleOutcome {
		let obj: T
		let p: Float
	}
	
	private var list: [PossibleOutcome] = [PossibleOutcome]()
	private var sum: Float = 0.0
	
	func add(_ obj: T, _ probability: Float) {
		list.append(PossibleOutcome(obj: obj, p: probability))
		sum += probability
	}
	
	func clear() {
		list.removeAll()
	}
	
	func getRandom() -> T? {
		if sum <= 0.0 {
			return list.randomElement()?.obj
		}
		
		let random = Float.random(in: 0.0 ... sum)
		var i: Float = 0.0
		
		for el in list {
			i += el.p
			if random < i {
				return el.obj
			}
		}
		
		return nil
	}
}

// @todo: move to tests
class ProbabilityArrayTests {
	enum ObjectType {
		case OutcomeOne
		case OutcomeTwo
		case OutcomeThree
	}
	
	class func test() {
		let arr = ProbabilityArray<ObjectType>()
		
		arr.add(.OutcomeOne, 0.3)
		arr.add(.OutcomeTwo, 0.5)
		arr.add(.OutcomeThree, 0.1)
		
		var countOne = 0
		var countTwo = 0
		var countThr = 0
		
		for _ in 0 ... 1000 {
			let randElement = arr.getRandom()
			
			assert(randElement != nil, "random array return nil")
			
			switch randElement! {
			case .OutcomeOne:
				countOne += 1
				
			case .OutcomeTwo:
				countTwo += 1
				
			case .OutcomeThree:
				countThr += 1
			}
		}
		
		print("1: \(countOne) 2: \(countTwo) 3: \(countThr)")
	}
}
