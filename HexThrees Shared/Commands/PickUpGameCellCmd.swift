//
//  PickUpGameCellCmd.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 08.04.20.
//  Copyright © 2020 Ilja Stepanow. All rights reserved.
//

import Foundation

class PickUpGameCellCmd: RunOnNodeCMD {
	override func run() {
		guard let value = self.node?.gameCell?.value else {
			assert(true, "PickUpGameCellCmd: value is not defined!")
			return
		}

		let deltaScore = self.gameModel.strategy[value] * self.gameModel.scoreMultiplier
		UpdateScoreCMD(self.gameModel).run(deltaScore)
		RemoveCellCMD(self.gameModel).run(cell: self.node!, delay: 0)
	}
}
