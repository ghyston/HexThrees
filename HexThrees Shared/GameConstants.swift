//
//  GameConstants.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 28.05.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

class GameConstants {
	static let BonusTurnsLifetime = 2
	static let MaxBonusesOnScreen = 3
	static let MaxBonusesOnPanel = 3
	static let TurnsToAutoSave = 5
	static let MaxFieldSize = 7
	static let StartFieldSize = 3
	
	// Animations
	static let SecondsPerCell = 0.20
	static let BonusAnimationDuration = 0.5
	static let GameOverScreenDelay = 1.2
	static let StressTimerInterval = 6.0
	static let StressTimerRollbackInterval = 0.5
	static let HelpVCAnimationDelay = 1.0
	static let BlockAnimationDuration = 1.0
	static let CellAppearAnimationDuration = 0.5
	static let CollectableUpdateAnimationDuration = 0.7
	static let ExpandFieldAnimationDuration = 1.0
	static let TutorialTextAppearDuration = 0.4
	static let TutorialNodesAppearDuration = 0.6
	
	// Probabilities
	static let RandomCellIsValue2Probability: Float = 0.3
	static let BaseBonusDropProbability = 0.2
	static let LockBonusProbability: Float =  0.5
	static let UnlockBonusProbability: Float = 0.3
	static let LastBlockedUnlockBonusProbability: Float = 0.05
	static let X2BonusProbability: Float = 0.2
	static let X3BonusProbability: Float = 0.1
	static let ExpandFieldOriginalProbability: Float = 0.7
	static let ExpandFieldDropProbability: Float = 0.25
	
	static let CollectableUnlockCellBonusProbability: Float = 1.0
	static let CollectableSwipeBlockBonusProbability: Float = 1.0
	static let CollectablePauseTimerBonusProbability: Float = 1.0
	static let CollectablePickUpBonusProbability: Float = 1.0
}

enum SettingsKey: String {
	case Palette = "palette"
	case MotionBlur = "motion_blur"
	case HapticFeedback = "haptic_feedback"
	case StressTimer = "stress_timer"
	case UseButtons = "use_buttons"
	case BestScore = "best_score"
	case TutorialShown = "tutorial_shown"
}
