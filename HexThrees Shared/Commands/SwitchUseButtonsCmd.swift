//
//  SwitchUseButtonsCmd.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 24.04.20.
//  Copyright © 2020 Ilja Stepanow. All rights reserved.
//

import Foundation

class SwitchUseButtonsCmd: GameCMD {
	func run(isOn: Bool) {
		self.gameModel.useButtonsEnabled = isOn
		NotificationCenter.default.post(name: .switchUseButtons, object: isOn)
		
		let useButtonsStatus = isOn
			? UseButtonStatus.Enabled
			: UseButtonStatus.Disabled
		
		UserDefaults.standard.set(useButtonsStatus.rawValue, forKey: SettingsKey.UseButtons.rawValue)
	}
}
