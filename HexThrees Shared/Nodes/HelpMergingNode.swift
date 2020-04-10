//
//  TutorialMergingNode.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 26.03.19.
//  Copyright © 2019 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

class HelpMergingNode : SKNode {
    
    var leftNode: GameCell
    var rightNode: GameCell
    let model: GameModel //@todo: weak?
    let valueLeft: Int
    let valueRight: Int
    let xPos: CGFloat
    
    init(model: GameModel, width: CGFloat, valueLeft: Int, valueRight: Int) {
        
        self.leftNode = GameCell(model: model, val: valueLeft)
        self.rightNode = GameCell(model: model, val: valueRight)
        self.model = model
        self.valueLeft = valueLeft
        self.valueRight = valueRight
        self.xPos = width / 4.0
        
        super.init()
        
        addChild(leftNode)
        addChild(rightNode)
        
        self.resetPosition()
        
        startAgain()
    }
    
    private func resetPosition() {
        
        leftNode.position.x = -self.xPos
        rightNode.position.x = self.xPos
    }
    
    @objc private func resetNodes() {
        
        self.leftNode.updateValue(
            value: self.valueLeft,
            strategy: self.model.strategy)
        self.rightNode.updateValue(
            value: self.valueRight,
            strategy: self.model.strategy)
        self.resetPosition()
    }
    
    @objc private func updateRight() {
        
        self.rightNode.updateValue(
			value: self.rightNode.value + 1,
			strategy: self.model.strategy,
			direction: .Left)
    }
    
    @objc private func moveAnimation() {
        
        MoveCellSpriteCMD(self.model).run(
            cell: self.leftNode,
            diff: CGVector(dx: self.xPos * 2, dy: 0),
            duration: GameConstants.HelpVCAnimationDelay)
    }
    
    @objc private func startAgain() {
        
        let randomDelay = Double.random / 2
        
        let startDelay = SKAction.wait(forDuration: GameConstants.HelpVCAnimationDelay * (randomDelay + 0.5) )
        let animation = SKAction.perform(#selector(HelpMergingNode.moveAnimation), onTarget: self)
        let updatedelay = SKAction.wait(forDuration: GameConstants.HelpVCAnimationDelay)
        let updateRight = SKAction.perform(#selector(HelpMergingNode.updateRight), onTarget: self)
        let resetDelay = SKAction.wait(forDuration: GameConstants.HelpVCAnimationDelay * (1.5 - randomDelay))
        let reset = SKAction.perform(#selector(HelpMergingNode.resetNodes), onTarget: self)
        let startAgain = SKAction.perform(#selector(HelpMergingNode.startAgain), onTarget: self)
        let sequence = SKAction.sequence([startDelay, animation, updatedelay, updateRight, resetDelay, reset, startAgain])
        
        self.run(sequence)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
