//
//  TutorialHighlightBonusCmd.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 01.06.20.
//  Copyright © 2020 Ilja Stepanow. All rights reserved.
//

import Foundation

class TutorialHighlightBonusCmd: GameCMD {
	
	var direction : SwipeDirection
	
	init(_ gameModel: GameModel, to direction: SwipeDirection) {
		self.direction = direction
		super.init(gameModel)
	}
	
	override func run() {
		guard let bgNode = self.gameModel.field[3, 3] else {
			return
		}
		let bonusNode = BonusFabric.createBy(bonus: .EXPAND_FIELD, gameModel: gameModel)
		bgNode.addBonus(bonusNode)
		
		let highlightDto = GameScene.HighlightCircleDto(
			coord: bgNode.position,
			rad: CGFloat(self.gameModel.geometry?.cellHeight ?? 50.0),
			delay: 0.0,
			name: TutorialNodeNames.BonusCell)
		
		NotificationCenter.default.post(name: .removeSceneHighlight, object: TutorialNodeNames.TimerCell)
		NotificationCenter.default.post(name: .addSceneHighlight, object: [highlightDto])
		NotificationCenter.default.post(name: .updateSceneDescription, object: descriptionText())
		
		gameModel.swipeStatus.restrictDirections(to: direction)
	}
	
	private func descriptionText() -> String {
		switch direction {
		case .Left:
            return "tutorial.swipeLeft".localized()
		case .Right:
            return "tutorial.swipeRight".localized()
		default:
            return "tutorial.swipeNowhere".localized() // actually, should never happen
		}
	}
}
