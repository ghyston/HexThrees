//
//  TutorialKeepSwipingCmd.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 05.06.20.
//  Copyright © 2020 Ilja Stepanow. All rights reserved.
//

import Foundation

class TutorialKeepSwipingCmd : GameCMD {
	override func run() {
        NotificationCenter.default.post(name: .updateSceneDescription, object: "tutorial.enjoy".localized())
	}
}
