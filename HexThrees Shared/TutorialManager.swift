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
	case DescriptionBg = "description_bg"
	case WelcomeHighlight = "welcome_highlight"
	case FirstCell = "first_cell"
	case SecondCell = "second_cell"
	case BonusCell = "bonus_cell"
	case TimerCell = "timer_cell"
	case PulsingActionName = "pulsing_description"
}

class TutorialManager {
	enum Steps: Int {
		case Welcome
		case HiglightFirstCell
		case MoveFirstCell
		case HighlightSecondCell
		case MoveFirstCellAgain
		case EveryTurnDescription
		case ShowTimer
		case AvoidTimer
		case HighlightBonus
		case MoveToPickBonus
		case KeepSwiping
		
		case Last
		
		static postfix func ++(l: inout Steps) {
			l = Steps(rawValue: l.rawValue + 1) ?? .Last
		}
	}
	
	private(set) var current: Steps?
	private var directionToCatchBonus: SwipeDirection?
	
	func inProgress() -> Bool {
		current != nil
	}
	
	func start(model: GameModel) {
		current = .Welcome
		cmdForCurrentStep(model, nil)?.run()
	}
	
	func finish() {
		current = nil
	}
	
	// This is hack to conditionaly change description if timer was missed
	func timerFailed() {
		if current == .ShowTimer {
			NotificationCenter.default.post(name: .updateSceneDescription, object: "keep swiping ↙️↘️")
		}
	}
	
	func triggerForStep(model: GameModel, param: Any? = nil, steps: Steps...) -> Bool {
		if steps.contains(where: { $0.rawValue - 1 == current?.rawValue }) {
			current?++
			cmdForCurrentStep(model, param)?.run()
			return true
		}
		return false
	}
	
	private func cmdForCurrentStep(_ model: GameModel, _ param: Any?) -> GameCMD? {
		switch current {
		case .Welcome:
			return TutorialStepWelcomeCmd(model)
		case .HiglightFirstCell:
			return TutorialStepHighlightFirstCellCmd(model)
		case .MoveFirstCell:
			return TutorialStepMoveFirstCellCmd(model)
		case .HighlightSecondCell:
			return TutorialStepHighlightSecondCellCmd(model)
		case .MoveFirstCellAgain:
			return TutorialStepMoveFirstCellAgainCmd(model)
		case .EveryTurnDescription:
			return TutorialEveryTurnDescriptionCmd(model)
		case .ShowTimer:
			return TutorialShowTimerCmd(model)
		case .AvoidTimer:
			let direction = param as? SwipeDirection ?? .XDown
			self.directionToCatchBonus = direction == .XDown
				? .Right
				: .Left
			return TutorialAvoidTimerCmd(model)
				.setup(to: direction)
		case .HighlightBonus:
			return TutorialHighlightBonusCmd(model, to: self.directionToCatchBonus!)
		case .MoveToPickBonus:
			return TutorialMoveToPickBonusCmd(model, to: self.directionToCatchBonus!)
		case .KeepSwiping:
			return TutorialKeepSwipingCmd(model)
			
		/* add new steps here */
		case .Last:
			return TutorialLastStepCmd(model)
		default:
			return nil
		}
	}
	
	func alreadyRun() -> Bool {
		UserDefaults.standard.bool(forKey: SettingsKey.TutorialShown.rawValue)
	}
}
