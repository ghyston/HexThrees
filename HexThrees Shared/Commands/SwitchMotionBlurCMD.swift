//
//  SwitchMotionBlurCMD.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 15.12.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class SwitchMotionBlurCMD: GameCMD {
	func run(isOn: Bool) {
		self.gameModel.motionBlurEnabled = isOn
		NotificationCenter.default.post(name: .switchMotionBlur, object: isOn)
	}
}
