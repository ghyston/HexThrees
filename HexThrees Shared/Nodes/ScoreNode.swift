//
//  ScoreNode.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 20.02.19.
//  Copyright © 2019 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

class ScoreLabel: UILabel {
	
	var previousValue: Int = 0
	var nextValue: Int = 0
	var currentValue: Int = 0 {
		didSet {
			self.text = formatter.string(from: NSNumber(value: currentValue))
		}
	}
	
	var formatter = NumberFormatter()
	
	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)!
		
		self.formatter.minimumIntegerDigits = 3
		
		if let gameModel = ContainerConfig.instance.tryResolve() as GameModel? {
			self.nextValue = gameModel.score
			self.scheduleNext()
		}
		
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(self.onScoreLabelUpdate),
			name: .updateScore,
			object: nil)
	}
	
	@objc func onScoreLabelUpdate(notification: Notification) {
		// @todo: not thread safety!! Use custome queue with .async(flags: .barrier) if there would be issues
		let isFinished = self.nextValue == self.currentValue
		self.nextValue = notification.object as? Int ?? 0
		
		// if score is descreased, do not run timers, just update value
		if self.nextValue < self.currentValue {
			self.currentValue = self.nextValue
		}
		
		if isFinished {
			self.scheduleNext()
		}
	}
	
	func scheduleNext() {
		if self.currentValue >= self.nextValue {
			return
		}
		
		let diff = Double(self.nextValue - self.currentValue)
		let period: Double = 0.2 / diff
		let diffPerFrame = Int((diff * 0.03).rounded(.up))
		
		self.currentValue = min(self.currentValue + diffPerFrame, self.nextValue)
		
		DispatchQueue.main.asyncAfter(deadline: .now() + period) {
			self.scheduleNext()
		}
	}
}
