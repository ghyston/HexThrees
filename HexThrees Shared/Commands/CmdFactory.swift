//
//  CmdFactory.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 11.10.19.
//  Copyright © 2019 Ilja Stepanow. All rights reserved.
//

import Foundation

protocol ICmdFactory {
	func TouchSelectableCell() -> RunOnNodeCMD
	func IncCollectableBonus(type: BonusType) -> GameCMD
	func LoadGame(save: SavedGame) -> GameCMD
	func AddRandomElements(cells: Int, blocked: Int) -> GameCMD
	func AddRandomCellForTutorial() -> GameCMD
	func AddRandomCellSkipRepeat() -> GameCMD
	func AddGameCell(addTo: BgCell) -> GameCMD
	func BlockRandomCell() -> GameCMD
	func CheckGameEnd() -> GameCMD
	func CleanGame() -> GameCMD
	
	func DoSwipe(direction: SwipeDirection) -> GameCMD
	func ApplyScoreBuff() -> GameCMD
	func AfterSwipe() -> GameCMD
}

func CmdFactory() -> ICmdFactory {
	let factory: ICmdFactory = ContainerConfig.instance.resolve()
	return factory
}

class GameCmdFactory: ICmdFactory {
	private let gameModel: GameModel
	
	init(_ model: GameModel) {
		self.gameModel = model
	}
	
	func create<T: GameCMD>(t: T.Type) -> T {
		return T(self.gameModel)
	}
	
	func TouchSelectableCell() -> RunOnNodeCMD {
		return TouchSelectableCellCmd(self.gameModel)
	}
	
	func IncCollectableBonus(type: BonusType) -> GameCMD {
		return IncCollectableBonusCmd(self.gameModel)
			.setup(type)
	}
	
	func LoadGame(save: SavedGame) -> GameCMD {
		return LoadGameCmd(self.gameModel)
			.setup(save)
	}
	
	func AddRandomElements(cells: Int, blocked: Int) -> GameCMD {
		return AddRandomElementsCmd(self.gameModel).setup(cells, blocked)
	}
	
	func AddRandomCellForTutorial() -> GameCMD {
		return AddRandomCellCmd(self.gameModel).forTutorial()
	}
	
	func AddRandomCellSkipRepeat() -> GameCMD {
		return AddRandomCellCmd(self.gameModel).skipRepeat()
	}
	
	func AddGameCell(addTo: BgCell) -> GameCMD {
		return AddGameCellCmd(self.gameModel)
			.setup(addTo: addTo)
	}
	
	func BlockRandomCell() -> GameCMD {
		return BlockRandomCellCmd(self.gameModel)
	}
	
	func CheckGameEnd() -> GameCMD {
		return CheckGameEndCmd(self.gameModel)
	}
	
	func CleanGame() -> GameCMD {
		return CleanGameCmd(self.gameModel)
	}
	
	func DoSwipe(direction: SwipeDirection) -> GameCMD {
		return DoSwipeCmd(self.gameModel)
			.setup(direction: direction)
	}
	
	func ApplyScoreBuff() -> GameCMD {
		return ApplyScoreBuffCmd(self.gameModel)
	}
	
	func AfterSwipe() -> GameCMD {
		return AfterSwipeCmd(self.gameModel)
	}
}
