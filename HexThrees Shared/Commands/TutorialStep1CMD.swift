//
//  TutorialStep1CMD.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 13.05.20.
//  Copyright © 2020 Ilja Stepanow. All rights reserved.
//

import Foundation

enum TutorialNodeNames : String {
	case Description = "description_label"
	case FirstCell = "first_cell"
	case SecondCell = "second_cell"
}

class TutorialManager {
	
	enum Steps {
		case HiglightFirstCell
		case MoveFirstCell
		case HighlightSecondCell
		case MoveFirstCellAgain
	}
	
	private (set) var current: Steps?
	
	func inProgress() -> Bool {
		current != nil
	}
	
	func start() {
		current = .HiglightFirstCell
	}
	
	func triggerForStep(model: GameModel, steps: Steps...) -> Bool {
		for step in steps {
			// @todo: if cast to int and if current - step = 1
			if step == .MoveFirstCell && current == .HiglightFirstCell {
				next()
				cmdForCurrentStep(model: model)?.run()
				return true
			}
			
			if step == .HighlightSecondCell && current == .MoveFirstCell {
				next()
				cmdForCurrentStep(model: model)?.run()
				return true
			}
			
			if step == .MoveFirstCellAgain && current == .HighlightSecondCell {
				next()
				cmdForCurrentStep(model: model)?.run()
				return true
			}
		}
		return false
	}
	
	func finish() {
		UserDefaults.standard.set(true, forKey: SettingsKey.TutorialShown.rawValue)
	}
	
	func cmdForCurrentStep(model: GameModel) -> GameCMD? {
		switch current {
		case .HiglightFirstCell:
			return TutorialStepHighlightFirstCellCmd(model)
		case .MoveFirstCell:
			return TutorialStepMoveFirstCellCmd(model)
		case .HighlightSecondCell:
			return TutorialStepHighlightSecondCellCmd(model)
		case .MoveFirstCellAgain:
			return TutorialStepMoveFirstCellAgainCmd(model)
		default:
			return nil
		}
	}
	
	//@todo: enum it ++!
	func next() {
		switch current {
		case .HiglightFirstCell:
			current = .MoveFirstCell
		case .MoveFirstCell:
			current = .HighlightSecondCell
		case .HighlightSecondCell:
			current = .MoveFirstCellAgain
		default:
			finish()
		}
	}
	
	func alreadyRun() -> Bool {
		false
		//UserDefaults.standard.bool(forKey: SettingsKey.TutorialShown.rawValue)
	}
	
}

class TutorialStepHighlightFirstCellCmd: GameCMD {
	override func run() {
		guard let bgCell = self.gameModel.field[2, 4] else {
			assert(false, "TutorialStep1Cmd: BgCell with coordinates (2, 4) is not exist")
			return
		}
		AddGameCellCmd(self.gameModel).setup(addTo: bgCell, isTutorial: false, value: 0).run()
		self.gameModel.swipeStatus.restrictDirections(to: .Right)
		
		let addHighlishDto = GameScene.HighlightCircleDto(
			coord: bgCell.position,
			rad: CGFloat(self.gameModel.geometry?.cellHeight ?? 50.0),
			delay: nil,
			name: TutorialNodeNames.FirstCell)
		NotificationCenter.default.post(name: .addSceneHighlight, object: [addHighlishDto])
		NotificationCenter.default.post(name: .updateSceneDescription, object: "swipe right →") //@todo: translate
		//@todo: add swipe node
	}
}

class TutorialStepMoveFirstCellCmd: GameCMD {
	override func run() {
		let moveHighlightDto = GameScene.HighlightCircleDto(
			coord: self.gameModel.geometry!.ToScreenCoord(AxialCoord(4, 2)),
			rad: 0,
			delay: nil,
			name: TutorialNodeNames.FirstCell)
		NotificationCenter.default.post(name: .moveSceneHighlight, object: moveHighlightDto)
	}
}

class TutorialStepHighlightSecondCellCmd: GameCMD {
	override func run() {
		guard let bgCellForNewCell = self.gameModel.field[4, 4] else {
			assert(false, "TutorialStep2Cmd: BgCell with coordinates (4, 4) is not exist")
			return
		}

		AddGameCellCmd(self.gameModel).setup(addTo: bgCellForNewCell, isTutorial: false, value: 0).run()
		self.gameModel.swipeStatus.restrictDirections(to: .YUp)
		
		let highlightDto = GameScene.HighlightCircleDto(
			coord: self.gameModel.geometry!.ToScreenCoord(AxialCoord(4, 4)),
			rad: CGFloat(self.gameModel.geometry?.cellHeight ?? 50.0),
			delay: 0.2,
			name: TutorialNodeNames.SecondCell)
		
		NotificationCenter.default.post(name: .addSceneHighlight, object: [highlightDto])
		NotificationCenter.default.post(name: .updateSceneDescription, object: "swipe up-left\nto combine cells ↖︎")
		//@todo: add swipe node
	}
}

class TutorialStepMoveFirstCellAgainCmd: GameCMD {
	override func run() {
		let moveHighlightDto = GameScene.HighlightCircleDto(
			coord: self.gameModel.geometry!.ToScreenCoord(AxialCoord(4, 4)),
			rad: 0,
			delay: nil,
			name: TutorialNodeNames.FirstCell)
		NotificationCenter.default.post(name: .moveSceneHighlight, object: moveHighlightDto)
	}
}
