//
//  DoPurchaseCmd.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 05.06.20.
//  Copyright © 2020 Ilja Stepanow. All rights reserved.
//

import Foundation

class PurchaseFullVersionCmd : GameCMD {
	override func run() {
		self.gameModel.purchased = true
		//UserDefaults.standard.set(true, forKey: SettingsKey.Purchased.rawValue) //@todo: uncomment it after testing
		self.gameModel.swipeStatus.unlockSwipes()
		
		//@todo: do actual stuff
	}
}
