//
//  TutorialStep1CMD.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 13.05.20.
//  Copyright © 2020 Ilja Stepanow. All rights reserved.
//

import Foundation

enum TutorialNodeNames: String {
	case Description = "description_label"
	case FirstCell = "first_cell"
	case SecondCell = "second_cell"
}

class TutorialManager {
	enum Steps: Int {
		case HiglightFirstCell
		case MoveFirstCell
		case HighlightSecondCell
		case MoveFirstCellAgain
		case Last
		
		static postfix func ++(l: inout Steps) {
			l = Steps(rawValue: l.rawValue + 1) ?? .Last
		}
	}
	
	private(set) var current: Steps?
	
	func inProgress() -> Bool {
		current != nil
	}
	
	func start() {
		current = .HiglightFirstCell
	}
	
	func finish() {
		current = nil
	}
	
	func triggerForStep(model: GameModel, steps: Steps...) -> Bool {
		if steps.contains(where: { $0.rawValue - 1 == current?.rawValue }) {
			current?++
			cmdForCurrentStep(model: model)?.run()
			return true
		}
		return false
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
			
		/* add new steps here */
		case .Last:
			return TutorialLastStepCmd(model)
		default:
			return nil
		}
	}
	
	func alreadyRun() -> Bool {
		false
		// UserDefaults.standard.bool(forKey: SettingsKey.TutorialShown.rawValue)
	}
}
