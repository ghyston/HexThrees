//
//  ScoreNode.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 20.02.19.
//  Copyright © 2019 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

class ScoreLabel : UILabel {
    
    enum UpdateSpeed: Int {
        
        case regular = 1
        case fast = 3
    }
    
    var previousValue : Int = 0
    var nextValue : Int = 0
    var currentValue : Int = 0 {
        didSet {
            self.text = formatter.string(from: NSNumber(value: currentValue))
        }
    }
    
    var formatter = NumberFormatter()
    
    required init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)!
        
        formatter.minimumIntegerDigits = 3
        
        if let gameModel = ContainerConfig.instance.tryResolve() as GameModel? {
            self.nextValue = gameModel.score
            scheduleNext(.fast)
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onScoreLabelUpdate),
            name: .updateScore,
            object: nil)
    }
    
    @objc func onScoreLabelUpdate(notification: Notification) {
        
        //@todo: not thread safety!! Use custome queue with .async(flags: .barrier) if there would be issues
        let isFinished = self.nextValue == self.currentValue
        self.nextValue = notification.object as? Int ?? 0
        
        if isFinished {
            scheduleNext(.fast)
        }
    }
    
    func scheduleNext(_ speed: UpdateSpeed) {
        
        if self.currentValue == self.nextValue {
            return
        }
        
        self.currentValue = min(self.currentValue + speed.rawValue, self.nextValue)
        
        //@todo: does it really neccesarry to use DispatchQueue for calculation score? Update from scene with time delta will be more appliable. However, if it is using not in scene UI 🤔
        let period : Double = 0.2 / Double(self.nextValue - self.currentValue)
        DispatchQueue.main.asyncAfter(deadline: .now() + period ) {
            self.scheduleNext(speed)
        }
    }
}
