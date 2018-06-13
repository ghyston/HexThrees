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
    
    let squareDistanceToDetect = sqr(20.0)
    let distanceToSwype = sqr(80.0)
    let rad30 = toRadian(30.0)
    let rad90 = toRadian(90.0)
    let rad150 = toRadian(150.0)
    
    var firstPoint:CGPoint = CGPoint.zero
    var lastPoint:CGPoint = CGPoint.zero
    var direction:SwipeDirection = .Unknown
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            self.firstPoint = touch.location(in: self.view)
            self.lastPoint = firstPoint
            printDebug("touch begin at: \(self.firstPoint)")
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else {
            return
        }
        
        let currentPoint = touch.location(in: self.view)
        printDebug("touch move at: \(currentPoint)")
        
        let diff = CGVector(from: lastPoint, to: currentPoint)
        if diff.squareLen() < squareDistanceToDetect {
            
            printDebug("diff too small")
            return
        }
        
        let direction = self.getDirection(vector: diff)
        printDebug("direction is: \(direction)")
        
        if self.direction != .Unknown && self.direction != direction {
            
            printDebug("Direction changed!")
            self.reset() //@todo: detect, what will happen here
            return
        }
        
        let sqrLenFromFirstTouch = CGVector(from: currentPoint, to: firstPoint).squareLen()
        if (sqrLenFromFirstTouch) > distanceToSwype {
            printDebug("Detect touch! sqrLenFromFirstTouch: \(sqrLenFromFirstTouch)")
            self.state = .ended
        }
        
        self.direction = direction
        self.lastPoint = currentPoint
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        printDebug("touchesEnded")
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        printDebug("touchesCancelled")
    }
    
    override func reset() {
        
        self.firstPoint = CGPoint.zero
        self.lastPoint = CGPoint.zero
        self.direction = .Unknown
        if self.state == .possible {
            self.state = .failed
        }
    }
    
    private func getDirection(vector: CGVector) -> SwipeDirection {
        
        let tang = atan2(-vector.dy, vector.dx) //minus because y increasing up
        
        if tang > 0 {
         
             if tang < rad30 {
                return .Right
             }
            
             if tang < rad90 {
                return .XUp
             }
            
             if tang < rad150 {
                return .YUp
             }
            
             return .Left
         
         } else {
         
             if tang > -rad30 {
                return .Right
             }
            
             if tang > -rad90 {
                return .YDown
             }
            
             if tang > -rad150 {
                return .XDown
             }
         
            return .Left
         }
    }
    
    private class func toRadian(_ degree: CGFloat) -> CGFloat {
        
        return (degree * .pi) / 180.0
    }
    
    private class func toDegree(_ rad: CGFloat) -> CGFloat {
        
        return rad * (180.0) / .pi
    }
    
    private class func sqr(_ val: CGFloat) -> CGFloat {
        return val * val;
    }
    
    private func printDebug(_ message: String) {
        
#if PRINT_TOUCH_DEBUG
        print(message)
#endif
    }
    
}
