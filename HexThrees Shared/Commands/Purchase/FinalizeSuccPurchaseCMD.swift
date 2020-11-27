//
//  FinalizeSuccPurchaseCMD.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 28.10.20.
//  Copyright © 2020 Ilja Stepanow. All rights reserved.
//

import Foundation

class FinalizeSuccPurchaseCMD : GameCMD {
	override func run() {
		self.gameModel.purchased = true
		UserDefaults.standard.set(true, forKey: SettingsKey.Purchased.rawValue)
	}
}
