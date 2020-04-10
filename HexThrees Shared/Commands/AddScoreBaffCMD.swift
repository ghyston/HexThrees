//
//  ApplyMultiplierToScoreCMD.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 31.08.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class AddScoreBaffCMD: GameCMD {
	private var factor: Int = 0
	
	func setup(factor: Int) -> GameCMD {
		self.factor = factor
		return self
	}
	
	override func run() {
		self.gameModel.scoreBuffs.append(
			ScoreBuff(
				turnsToApply: 3,
				factor: self.factor))
		
		self.gameModel.recalculateScoreBaff()
		
		NotificationCenter.default.post(
			name: .scoreBuffUpdate,
			object: self.gameModel.scoreMultiplier)
	}
}
