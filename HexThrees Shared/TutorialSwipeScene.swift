//
//  TutorialSwipeScene.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 04.04.19.
//  Copyright © 2019 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

class TutorialSwipeScene : SKScene {
    
    let model : GameModel
    
    init(frameSize : CGSize) {
        
        self.model = GameModel(
            screenWidth: frameSize.width * 0.9,
            fieldSize: FieldSize.Quaddro.rawValue,
            strategy: MerginStrategyFabric.createByName(.Tutorial),
            motionBlur: false,
            hapticFeedback: false)
        
        super.init(size: CGSize(width: 1200, height: 1200))
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scaleMode = .resizeFill
        
        addChild(TutorialSwipeNode(model: self.model, width: frameSize.width, scene: self))
        
        startAnimation()
    }
    
    private func startAnimation() {
        
        let startDelay = SKAction.wait(forDuration: GameConstants.TutorialAnimationDelay)
        let animation = SKAction.perform(#selector(TutorialSwipeScene.doRandomSwipe), onTarget: self)
        let sequence = SKAction.sequence([startDelay, animation])
        let repeatAction = SKAction.repeatForever(sequence)
        self.run(repeatAction)
    }
    
    @objc private func doRandomSwipe() {
        
        var allDirections = SwipeDirection.allCases.shuffled()
        
        while !allDirections.isEmpty {
            let direction = allDirections.popLast()!
            guard let iterator = IteratorFabric.create(self.model, direction) else {
                continue
            }
            
            while let line = iterator.next() {
                if(line.check(strategy: self.model.strategy)) {
                    DoSwipeCMD(self.model).run(direction: direction.inverse())
                    return
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
