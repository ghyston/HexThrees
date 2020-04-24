//
//  SwitchHapticFeedback.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 16.12.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class SwitchHapticFeedbackCMD: GameCMD {
	func run(isOn: Bool) {
		let hapticFeedbackStatus = isOn ?
			HapticFeedbackStatus.Enabled :
			HapticFeedbackStatus.Disabled

		UserDefaults.standard.set(hapticFeedbackStatus.rawValue, forKey: SettingsKey.HapticFeedback.rawValue)
		self.gameModel.hapticManager.isEnabled = isOn
	}
}
