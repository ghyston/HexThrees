//
//  SelectNodeCMD.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 07.10.19.
//  Copyright © 2019 Ilja Stepanow. All rights reserved.
//

import Foundation

class StartCellSelectionCMD: GameCMD {
	func run(comparator: CellComparator, onSelectCmd: RunOnNodeCMD) {
		let toggleHighlight: (_: BgCell) -> Void = {
			if comparator($0) {
				$0.highlight()
			}
			else {
				$0.shade()
			}
		}

		RollbackTimerCMD(self.gameModel).run()
		gameModel.field.executeForAll(lambda: toggleHighlight)
		self.gameModel.selectCMD = onSelectCmd
		self.gameModel.swipeStatus.lockSwipes()
	}
}
