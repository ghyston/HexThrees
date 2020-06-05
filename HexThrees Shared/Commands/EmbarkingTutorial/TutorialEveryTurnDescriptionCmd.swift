//
//  TutorialEveryTurnDescriptionCmd.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 01.06.20.
//  Copyright © 2020 Ilja Stepanow. All rights reserved.
//

import Foundation

class TutorialEveryTurnDescriptionCmd : GameCMD {
	override func run() {
		NotificationCenter.default.post(name: .removeSceneHighlight, object: TutorialNodeNames.SecondCell)
		NotificationCenter.default.post(name: .updateSceneDescription, object: "new cell appear\nevery swipe")
	}
}
