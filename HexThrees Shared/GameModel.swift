//
//  GameModel.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 23.05.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

class GameModel {
	var strategy: MergingStrategy
	var geometry: FieldGeometry?
	var hapticManager: IHapticManager
	var tutorialManager = TutorialManager()
	
	var motionBlurEnabled: Bool
	var useButtonsEnabled: Bool
	
	var stressTimer: ITimerModel
	
	// Some common properties
	var field: HexField
	var swipeStatus = SwipeStatus()
	var score: Int = 0
	var scoreBuffs = [ScoreBuff]()
	var scoreMultiplier: Int = 1
	var turnsWithoutBonus: Int = 0
	var turnsWithoutSave: Int = 0
	
	var selectedBonusType: BonusType?
	var selectCMD: RunOnNodeCMD?
	var collectableBonuses = [BonusType: CollectableBonusModel]()
	
	func recalculateScoreBaff() {
		self.scoreMultiplier = 1
		for buff in self.scoreBuffs {
			self.scoreMultiplier *= buff.factor
		}
	}
	
	init(strategy: MergingStrategy, motionBlur: Bool, hapticFeedback: Bool, timerEnabled: Bool, useButtons: Bool) {
		self.strategy = strategy
		self.field = HexField()
		self.motionBlurEnabled = motionBlur
		self.useButtonsEnabled = useButtons
		self.hapticManager = HapticManager(enabled: hapticFeedback)
		
		self.stressTimer = TimerModel()
		if timerEnabled {
			self.stressTimer.enable()
		}
		self.resetCollectables()
	}
	
	func reset(strategy: MergingStrategy) {
		self.strategy = strategy
		self.field = HexField()
		self.resetCollectables()
	}
	
	private func resetCollectables() {
		self.collectableBonuses.removeAll()
	}
}
