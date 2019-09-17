//
//  NotificationNameExtension.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 01.07.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

extension NSNotification.Name {
    static let resetGame = Notification.Name(rawValue: "reset_game")
    static let updateScore = Notification.Name(rawValue: "update_score")
    static let gameOver = Notification.Name(rawValue: "gameOver")
    static let switchPalette = Notification.Name(rawValue: "switch_palette")
    static let switchMotionBlur = Notification.Name(rawValue: "switch_motion_blur")
    static let switchHapticFeedback = Notification.Name(rawValue: "switch_haptic_feedback")
    static let scoreBuffUpdate = Notification.Name(rawValue: "score_buff_update")
    static let pauseTimers = Notification.Name(rawValue: "pause_timers")
    static let updateCollectables = Notification.Name(rawValue: "update_collectables")
}
