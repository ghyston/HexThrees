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
}
