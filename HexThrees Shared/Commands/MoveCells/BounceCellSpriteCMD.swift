//
//  BounceCellSpriteCMD.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 05.10.20.
//  Copyright © 2020 Ilja Stepanow. All rights reserved.
//

import Foundation

class BounceCellSpriteCMD : GameCMD {
	func run(cell: GameCell, direction: SwipeDirection, gapCount: Int, duration: Double) {
		gameModel.swipeStatus.incrementDelay(delay: duration)
		
		let linearDiff = Double(gameModel.geometry!.gap * (1 + Float(gapCount) * 0.2))
		let angle = direction.angle()
		
		let diff = CGVector(
			dx: linearDiff * cos(angle),
			dy: linearDiff * sin(angle))
		
		cell.playBounceAnimation(
			diff: diff,
			duration: duration)
	}
}
