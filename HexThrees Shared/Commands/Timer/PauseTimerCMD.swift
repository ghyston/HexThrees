//
//  PauseTimerCMD.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 12.09.19.
//  Copyright © 2019 Ilja Stepanow. All rights reserved.
//

import Foundation

class PauseTimerCMD: GameCMD {
	override func run() {
		NotificationCenter.default.post(name: .pauseTimers, object: nil)
		self.gameModel.stressTimer.fire()
	}
}
