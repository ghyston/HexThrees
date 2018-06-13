//
//  File.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 29.05.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

//@todo: this should be struct, GameModel too, !!BUT!! gameModel logic should be class (to use by ref)
class SwipeStatus {
    var inProgress : Bool = false
    var somethingChangeed : Bool = false
    var delay : Double = 0.0

    func incrementDelay(delay : Double) {
        
        self.delay = max(delay, self.delay)
    }
}
