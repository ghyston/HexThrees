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
    
    let distanceToDetect : CGFloat = 4.0
    let distanceToSwype : CGFloat = 200.0
    
    enum Direction {
        case Unknown
        case XUp
        case XDown
        case YUp
        case YDown
        case Left
        case Right
    }
    
    var firstPoint:CGPoint = CGPoint.zero
    var lastPoint:CGPoint = CGPoint.zero
    var direction:Direction = .Unknown
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            self.firstPoint = touch.location(in: self.view)
            self.lastPoint = firstPoint
        }
    }
    
    //@todo: code review!!!
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else {
            return
        }
        
        let currentPoint = touch.location(in: self.view)
        
        let diff = CGVector(
            dx: currentPoint.x - lastPoint.x,
            dy: currentPoint.y - lastPoint.y)
        
        let sqrLen = diff.dx * diff.dx + diff.dy * diff.dy
        if sqrLen < distanceToDetect {
            return
        }
        
        let angle = self.angleToX(vector: diff)
        
        let direction = self.angleToDirection(tan: angle)
        print("\(direction)")
        
        if self.direction != .Unknown && self.direction != direction {
            self.reset()
            return
        }
        
        let diff2 = CGVector(
            dx: currentPoint.x - firstPoint.x,
            dy: currentPoint.y - firstPoint.y)
        
        let sqrLen2 = diff2.dx * diff2.dx + diff2.dy * diff2.dy
        
        if (sqrLen2) > distanceToSwype {
            self.state = .ended
        }
        
        self.direction = direction
        self.lastPoint = currentPoint
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        /*guard let touch = touches.first else {
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
        
        self.state = .ended*/
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func reset() {
        
        self.firstPoint = CGPoint.zero
        self.lastPoint = CGPoint.zero
        self.direction = .Unknown
        if self.state == .possible {
            self.state = .failed
        }
    }
    
    private func angleToX(vector: CGVector) -> CGFloat {
        
        return atan2(vector.dy, vector.dx)
    }
    
    private func angleToDirection(tan: CGFloat) -> Direction {
        
        //@todo: simplify?
        
        if tan <= 0 {
            
            if tan > -0.471 { // -30 grad
                return .Right
            }
            
            if tan > -1.414 { // -150 grad
                return .XUp
            }
            
            if tan > -2.3562 { // -150 grad
                return .YUp
            }
            
            return .Left
            
        } else {
            
            if tan < 0.471 { // 30 grad
                return .Right
            }
            
            if tan < 1.414 { // -150 grad
                return .YDown
            }
            
            if tan < 2.3562 { // -150 grad
                return .XDown
            }
            
            return .Left
        }
        
        return .Unknown
    }
    
}
