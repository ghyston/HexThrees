//
//  GameModel.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 23.05.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

protocol ICellsStatisticCalculator {
    
    func next(cell: BgCell)
    func clean()
}

class GameModel {
    
    var strategy: MergingStrategy
    var geometry: FieldGeometry
    var hapticManager: IHapticManager
    var motionBlurEnabled: Bool
    
    var stressTimer : ITimerModel
    
    // Some common properties
    var field : HexField
    var swipeStatus = SwipeStatus()
    var score : Int = 0
    var scoreBuffs = [ScoreBuff]()
    var scoreMultiplier : Int = 1
    var turnsWithoutBonus : Int = 0
    
    func recalculateScoreBaff(){
        
        self.scoreMultiplier = 1
        for buff in scoreBuffs {
            self.scoreMultiplier *= buff.factor
        }
    }
    
    init(screenWidth: CGFloat, fieldSize: Int, strategy: MergingStrategy, motionBlur: Bool, hapticFeedback: Bool, timerEnabled: Bool) {
        
        self.geometry = FieldGeometry(
            screenWidth: screenWidth,
            fieldSize: fieldSize)
        self.strategy = strategy
        self.field = HexField(
            width: fieldSize,
            height: fieldSize,
            geometry: self.geometry)
        self.motionBlurEnabled = motionBlur
        self.hapticManager = HapticManager(enabled: hapticFeedback)
        
        self.stressTimer = TimerModel()
        if (timerEnabled) {
            self.stressTimer.enable()
        }
    }
    
    func reset(screenWidth: CGFloat, fieldSize: Int, strategy: MergingStrategy) {
        
        self.geometry = FieldGeometry(
            screenWidth: screenWidth,
            fieldSize: fieldSize)
        self.strategy = strategy
        self.field = HexField(
            width: fieldSize,
            height: fieldSize,
            geometry: self.geometry)
    }
}
