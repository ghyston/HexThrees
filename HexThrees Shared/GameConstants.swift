//
//  GameConstants.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 28.05.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

class GameConstants {
    
    static let SecondsPerCell = 0.15
    
    static let BonusAnimationDuration = 0.5
    static let BonusTurnsLifetime = 2
    static let BaseBonusDropProbability = 0.1
    static let MaxBonusesOnScreen = 3
    static let GameOverScreenDelay = 1.2
    
    static let LockBonusProbability: Float = 0.5
    static let UnlockBonusProbability: Float = 0.3
    static let LastBlockedUnlockBonusProbability: Float = 0.05
    static let X2BonusProbability: Float = 0.2
    static let X3BonusProbability: Float = 0.1
}

enum SettingsKey : String {
    
    case FieldSize = "field_size"
    case Palette = "palette"
    case MotionBlur = "motion_blur"
    case HapticFeedback = "haptic_feedback"
}
