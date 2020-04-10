//
//  UpdateBonusesCounterCMD.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 28.08.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class UpdateBonusesCounterCMD: GameCMD {
	private func updateBonusCounter(cell: BgCell) {
		if let bonus = cell.bonus {
			if bonus.decCount() {
				cell.removeBonusWithDisposeAnimation()
			}
		}
	}

	override func run() {
		self.gameModel.field.executeForAll(lambda: self.updateBonusCounter)
	}
}
