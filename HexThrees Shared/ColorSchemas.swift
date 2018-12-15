//
//  ColorSchemas.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 17.10.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

enum ColorSchemaType : Int {
    case Dark = 1
    case Gray = 2
    case Light = 3
    case Blue = 4
}

struct ColorSchema {
    
    var fieldOutlineColor : SKColor
    var sceneBgColor : SKColor
    var cellBgColor : SKColor
    var cellBlockedBgColor : SKColor
    var colors: Dictionary<Int, SKColor>
}

//@todo: move to another file ?
enum FieldSize : Int {
    
    //case Min = Thriple
    case Thriple = 3
    case Quaddro = 4
    case Pento = 5
    //case Max = Pento
    
    //let min = { return .Thriple}
}
