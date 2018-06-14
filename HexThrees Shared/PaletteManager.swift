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
        [1: SKColor(rgb: 0xE9E228),
         2: SKColor(rgb: 0xBDB962),
         3: SKColor(rgb: 0xD8D35C),
         5: SKColor(rgb: 0xF1E800),
         8: SKColor(rgb: 0xFFF500),
         
         13: SKColor(rgb: 0xE99528),
         21: SKColor(rgb: 0xBD9562),
         34: SKColor(rgb: 0xD8A25C),
         55: SKColor(rgb: 0xF18800),
         89: SKColor(rgb: 0xFF9000),
         144: SKColor(rgb: 0x9CEAEF),
         233: SKColor(rgb: 0x07BEB8)]
    
  
    
  /*  #216596
    #436279
    #406C8B
    #075E9B
    #0568AE*/
    
    /*shade 0 = #66239D = rgb(102, 35,157) = rgba(102, 35,157,1) = rgb0(0.4,0.137,0.616)
    shade 1 = #65467F = rgb(101, 70,127) = rgba(101, 70,127,1) = rgb0(0.396,0.275,0.498)
    shade 2 = #6E4491 = rgb(110, 68,145) = rgba(110, 68,145,1) = rgb0(0.431,0.267,0.569)
    shade 3 = #5D08A2 = rgb( 93,  8,162) = rgba( 93,  8,162,1) = rgb0(0.365,0.031,0.635)
    shade 4 = #6706B5 = rgb(103,  6,181) = rgba(103,  6,181,1) = rgb0(0.404,0.024,0.71)
    
   
    *** Secondary color (2):
    
    shade 0 = #216596 = rgb( 33,101,150) = rgba( 33,101,150,1) = rgb0(0.129,0.396,0.588)
    shade 1 = #436279 = rgb( 67, 98,121) = rgba( 67, 98,121,1) = rgb0(0.263,0.384,0.475)
    shade 2 = #406C8B = rgb( 64,108,139) = rgba( 64,108,139,1) = rgb0(0.251,0.424,0.545)
    shade 3 = #075E9B = rgb(  7, 94,155) = rgba(  7, 94,155,1) = rgb0(0.027,0.369,0.608)
    shade 4 = #0568AE = rgb(  5,104,174) = rgba(  5,104,174,1) = rgb0(0.02,0.408,0.682)
    
    *** Complement color:*/
    
    
    
}
