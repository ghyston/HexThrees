//
//  RollbackTimerCMD.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 26.05.19.
//  Copyright © 2019 Ilja Stepanow. All rights reserved.
//

import Foundation

class RollbackTimerCMD: GameCMD {
	override func run() {
		guard gameModel.stressTimer.isEnabled() else {
			return
		}
		
		gameModel.stressTimer.cancelDelayedStart() 

		self.gameModel.stressTimer.getCell()?.playRollbackCircleAnimation()
		self.gameModel.stressTimer.stop()
	}
}
