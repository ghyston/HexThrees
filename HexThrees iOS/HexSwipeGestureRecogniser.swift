//
//  HexSwipeGestureRecogniser.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 30.05.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation
import os
import UIKit

extension OSLog {
	static let gestures: OSLog = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "gestures")
	static let motionBlur: OSLog = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "motionBlur")
}

class HexSwipeGestureRecogniser: UIGestureRecognizer {
	let squareDistanceToDetect = sqr(20.0)
	let distanceToSwype = sqr(60.0)
	let rad30 = toRadian(30.0)
	let rad90 = toRadian(90.0)
	let rad150 = toRadian(150.0)
	
	// let osLog =
	
	var firstPoint: CGPoint = CGPoint.zero
	var lastPoint: CGPoint = CGPoint.zero
	var direction: SwipeDirection = .Unknown
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		os_signpost(.begin, log: .gestures, name: "swipe")
		if let touch = touches.first {
			self.firstPoint = touch.location(in: self.view)
			self.lastPoint = self.firstPoint
			os_log("touch begin x:%f y: %f", log: .gestures, type: .info, self.firstPoint.x, self.firstPoint.y)
		}
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first else {
			return
		}
		
		let currentPoint = touch.location(in: self.view)
		os_log("touch move x:%f y: %f", log: .gestures, type: .info, currentPoint.x, currentPoint.y)
		
		let diff = CGVector(from: lastPoint, to: currentPoint)
		if diff.squareLen() < self.squareDistanceToDetect {
			os_log("diff too small %f", log: .gestures, type: .info, diff.squareLen())
			return
		}
		
		let direction = self.getDirection(vector: diff)
		os_log("direction is: %s", log: .gestures, type: .info, String(describing: direction))
		
		if self.direction != .Unknown, self.direction != direction {
			os_log("direction changed", log: .gestures, type: .info)
			self.reset() // @todo: detect, what will happen here
			return
		}
		
		let sqrLenFromFirstTouch = CGVector(from: currentPoint, to: firstPoint).squareLen()
		if sqrLenFromFirstTouch > self.distanceToSwype {
			os_log("touch detected %f %s", log: .gestures, type: .info, sqrLenFromFirstTouch, String(describing: direction))
			self.state = .ended
		}
		
		self.direction = direction
		self.lastPoint = currentPoint
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		os_log("touch ended", log: .gestures, type: .info)
		os_signpost(.end, log: .gestures, name: "swipe")
	}
	
	override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
		os_log("touch cancelled", log: .gestures, type: .info)
		os_signpost(.end, log: .gestures, name: "swipe")
	}
	
	override func reset() {
		os_signpost(.end, log: .gestures, name: "swipe")
		self.firstPoint = CGPoint.zero
		self.lastPoint = CGPoint.zero
		self.direction = .Unknown
		if self.state == .possible {
			self.state = .failed
		}
	}
	
	// @todo: good candidate to write tests and make switch on range
	private func getDirection(vector: CGVector) -> SwipeDirection {
		let tang = atan2(-vector.dy, vector.dx) // minus because y increasing up
		
		if tang > 0 {
			if tang < self.rad30 {
				return .Right
			}
			
			if tang < self.rad90 {
				return .XUp
			}
			
			if tang < self.rad150 {
				return .YUp
			}
			
			return .Left
			
		} else {
			if tang > -self.rad30 {
				return .Right
			}
			
			if tang > -self.rad90 {
				return .YDown
			}
			
			if tang > -self.rad150 {
				return .XDown
			}
			
			return .Left
		}
	}
	
	private class func toRadian(_ degree: CGFloat) -> CGFloat { (degree * .pi) / 180.0 }
	
	private class func toDegree(_ rad: CGFloat) -> CGFloat { rad * 180.0 / .pi }
	
	private class func sqr(_ val: CGFloat) -> CGFloat { return val * val }
}
