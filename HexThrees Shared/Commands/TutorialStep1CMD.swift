//
//  TutorialStep1CMD.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 13.05.20.
//  Copyright © 2020 Ilja Stepanow. All rights reserved.
//

import Foundation

class TutorialStep1Cmd: GameCMD {
	override func run() {
		guard let bgCell = self.gameModel.field[0, 2] else {
			assert(true, "TutorialStep1Cmd: BgCell with coordinates (0, 2) is not exist")
			return
		}
		AddGameCellCmd(self.gameModel).setup(addTo: bgCell).run()
		self.gameModel.swipeStatus.restrictDirections(to: .Right)
		//@todo: add swipe node
		//@todo: add description to scene
		//@todo: add highlight node to scene
	}
}
