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
    
    var previousValue : Int
    var currentValue : Int
    var animationDuration: Double
    var formatter = NumberFormatter()
    
    var newText : String = ""
    
    required init(coder aDecoder: NSCoder) {
        
        self.currentValue = 0
        self.previousValue = 0
        self.animationDuration = 0
        
        super.init(coder: aDecoder)!
        
        formatter.minimumIntegerDigits = 3
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onScoreLabelUpdate),
            name: .updateScore,
            object: nil)
    }
    
    func animate(characterDelay: TimeInterval) {
        
        //@todo: check, what is OperationQueue and can it be used here?
        //let queue = DispatchQueue.init(label: "scoreUpdate")
        
        DispatchQueue.main.async {
            
            let count = min(10, self.currentValue - self.previousValue)
            for i in 1...count {
                
                let part : Double = 1 / Double(pow(2.7, Double(count - i)))
                DispatchQueue.main.asyncAfter(deadline: .now() + characterDelay * part ) {
                    let tempValue = self.previousValue + (i + 1) * (self.currentValue - self.previousValue) / count
                    self.updateText(value: tempValue)
                }
            }
        }
    }
    
    @objc func onScoreLabelUpdate(notification: Notification) {
        
        self.previousValue = self.currentValue
        self.currentValue = notification.object as? Int ?? 0
        
        animate(characterDelay: 0.3)
    }
    
    private func updateText(value: Int) {
        
        self.text = formatter.string(from: NSNumber(value: value))
    }
}
