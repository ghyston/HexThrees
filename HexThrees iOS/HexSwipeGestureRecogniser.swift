//
//  HexSwipeGestureRecogniser.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 30.05.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation
import UIKit

class HexSwipeGestureRecogniser : UIGestureRecognizer {
    
    let distanceToDetect = 200
    
    enum Direction {
        case Unknown
        case XUp
        case XDown
        case YUp
        case YDown
        case Left
        case Right
    }
    
    var gestureStart:CGPoint = CGPoint.zero
    var direction:Direction = .Unknown
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            self.gestureStart = touch.location(in: self.view)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else {
            return
        }
        
        let gestureEnd = touch.location(in: self.view)

        let diff = CGVector(
            dx: gestureEnd.x - gestureStart.x,
            dy: gestureEnd.y - gestureStart.y)
        
        if diff.dx < -500 {
            self.direction = .Left
        }
        else if diff.dx > 500 {
            self.direction = .Right
        } else if diff.dx < 0 && diff.dy < 0 {
            self.direction = .XDown
        }
        else if diff.dx < 0 && diff.dy > 0 {
            self.direction = .YUp
        }
        else if diff.dx > 0 && diff.dy < 0 {
            self.direction = .YDown
        }
        else if diff.dx > 0 && diff.dy > 0 {
            self.direction = .XUp
        }
        
        self.state = .ended
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
}
