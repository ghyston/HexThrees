//
//  IteratorFabric.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 23.04.19.
//  Copyright © 2019 Ilja Stepanow. All rights reserved.
//

import Foundation

class IteratorFabric {
    
    class func create(_ model : GameModel, _ direction : SwipeDirection) -> CellsIterator? {
        
        switch direction {
        case .Left:
            return MoveLeftIterator(model)
        case .Right:
            return MoveRightIterator(model)
        case .XUp:
            return MoveXUpIterator(model)
        case .YUp:
            return MoveYUpIterator(model)
        case .XDown:
            return MoveXDownIterator(model)
        case .YDown:
            return MoveYDownIterator(model)
        case .Unknown:
            fallthrough
        default:
            return nil
        }
    }
}
