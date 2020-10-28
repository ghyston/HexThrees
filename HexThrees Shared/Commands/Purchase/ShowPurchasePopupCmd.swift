//
//  ShowPurchasePopupCmd.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 05.06.20.
//  Copyright © 2020 Ilja Stepanow. All rights reserved.
//

import Foundation

class ShowPurchasePopupCmd : GameCMD {
	override func run() {
		NotificationCenter.default.post(name: .freeLimitReached, object: nil)
		self.gameModel.swipeStatus.lockSwipes()
		RollbackTimerCMD(gameModel).run()
	}
}
