//
//  TutorialLastSetpCmd.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 29.05.20.
//  Copyright © 2020 Ilja Stepanow. All rights reserved.
//

import Foundation

class TutorialLastStepCmd: GameCMD {
	override func run() {
		NotificationCenter.default.post(name: .cleanTutorialScene, object: nil)
		UserDefaults.standard.set(true, forKey: SettingsKey.TutorialShown.rawValue)
		self.gameModel.swipeStatus.removeDriectionRestrictions()
		self.gameModel.tutorialManager.finish()
	}
}

