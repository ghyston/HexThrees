//
//  NotificationNameExtension.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 01.07.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

extension NSNotification.Name {
    static let resetGame = Notification.Name(rawValue: "resetGame")
    static let updateScore = Notification.Name(rawValue: "updateScore")
    static let gameOver = Notification.Name(rawValue: "gameOver")
    static let switchPalette = Notification.Name(rawValue: "switchPalette")
}
