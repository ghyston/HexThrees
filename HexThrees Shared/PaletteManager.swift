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
    
    static func cellBlockedBgColor() -> SKColor {
        return .darkGray
    }
    
    //@todo: index should not depend on strategy!!!
    
    /*static private let colors: Dictionary =
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
         233: SKColor(rgb: 0x07BEB8)]*/
    
    static private let colors: Dictionary =
        [1: SKColor(rgb: 0xfffafb),
         2: SKColor(rgb: 0xE9E228),
         4: SKColor(rgb: 0xBDB962),
         3: SKColor(rgb: 0xBDB962),
         5: SKColor(rgb: 0xD8D35C),
         8: SKColor(rgb: 0xF1E800),
         
         13: SKColor(rgb: 0xE99528),
         16: SKColor(rgb: 0xE99528),
         21: SKColor(rgb: 0xBD9562),
         32: SKColor(rgb: 0xBD9562),
         34: SKColor(rgb: 0xD8A25C),
         55: SKColor(rgb: 0xF18800),
         64: SKColor(rgb: 0xF18800),
         89: SKColor(rgb: 0xFF9000),
         144: SKColor(rgb: 0x9CEAEF),
         233: SKColor(rgb: 0x07BEB8),
         
         377: SKColor(rgb: 0x216596),
         610: SKColor(rgb: 0x436279),
         987: SKColor(rgb: 0x436279),
         1597: SKColor(rgb: 0x406C8B),
         2584: SKColor(rgb: 0x075E9B),
         4181: SKColor(rgb: 0x0568AE),
         6765: SKColor(rgb: 0x07BEB8)]
    
}
