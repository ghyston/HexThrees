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

enum ColorSchemaType {
    case Dark
    case Gray
    case Light
    case Blue
}

struct ColorSchema {
    
    var bgColor : SKColor
    var sceneBgColor : SKColor
    var cellBgColor : SKColor
    var cellBlockedBgColor : SKColor
    var colors: Dictionary<Int, SKColor>
}
