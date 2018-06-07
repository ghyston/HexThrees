//
//  PaletteManager.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 07.06.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

class PaletteManager {
    
    static func color(value: Int) -> SKColor {
    
        //@todo: add checking for existance
        return colors[value]!
    }
    
    static func cellBgColor() -> SKColor {
        return .gray
    }
    
    static private let colors: Dictionary =
        [1: SKColor(rgb: 0xfffafb),
         2: SKColor(rgb: 0x7de2d1),
         3: SKColor(rgb: 0x339989),
         5: SKColor(rgb: 0x2b2c28),
         8: SKColor(rgb: 0x131515),
         
         13: SKColor(rgb: 0xDCC7BE),
         21: SKColor(rgb: 0xCBB9A8),
         34: SKColor(rgb: 0x145C9E),
         55: SKColor(rgb: 0x0B4F6C),
         89: SKColor(rgb: 0x405138),
         144: SKColor(rgb: 0x9CEAEF),
         233: SKColor(rgb: 0x07BEB8)]
}
