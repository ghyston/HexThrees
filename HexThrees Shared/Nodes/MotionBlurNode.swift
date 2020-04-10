//
//  MotionBlurNode.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 06.12.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

protocol MotionBlurNode: class {
	var effectNode: SKEffectNode { get set }
	var blurFilter: CIFilter { get set }
	var prevPosition: CGPoint? { get set }
	var prevDelta: Double? { get set }
	var motionBlurDisabled: Bool { get set }
	
	func disableBlur()
	func enableBlur()
	
	func addBlur()
	func startBlur()
	func stopBlur()
	func updateMotionBlur(_ deltaTime: TimeInterval)
}

extension MotionBlurNode where Self: SKNode {
	func addBlur() {
		blurFilter = CIFilter(name: "CIMotionBlur")!
		addChild(effectNode)
	}
	
	func startBlur() {
		if motionBlurDisabled {
			return
		}
		
		effectNode.filter = blurFilter
		blurFilter.setValue(0, forKey: kCIInputRadiusKey)
		prevPosition = nil
		prevDelta = nil
	}
	
	func stopBlur() {
		effectNode.filter = nil
		prevPosition = nil
		prevDelta = nil
	}
	
	func updateMotionBlur(_ deltaTime: TimeInterval) {
		if effectNode.filter == nil {
			return
		}
		
		if prevPosition == nil || prevDelta == nil {
			prevPosition = self.position
			prevDelta = deltaTime
			return
		}
		
		let diff = CGVector(from: self.prevPosition!, to: self.position)
		self.prevPosition = self.position
		
		let magic = 350.0
		let fpsFactor = CGFloat(prevDelta! * magic)
		prevDelta = deltaTime
		
		let angle = atan2(diff.dy, diff.dx)
		let len = diff.squareLen()
		let velocity = len / fpsFactor
		
		blurFilter.setValue(angle, forKey: kCIInputAngleKey)
		blurFilter.setValue(velocity, forKey: kCIInputRadiusKey)
	}
	
	func disableBlur() {
		motionBlurDisabled = true
	}
	
	func enableBlur() {
		motionBlurDisabled = false
	}
}
