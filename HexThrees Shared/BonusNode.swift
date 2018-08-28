//
//  BonusNode.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 27.08.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

enum BonusType {
    case blockCell
    case unblockCell
    case x2Points
}

class BonusNode : SKNode {
    
    let sprite : SKSpriteNode
    let command : GameCMD
    
    init(spriteName: String, command: GameCMD) {
        
        self.sprite = SKSpriteNode(imageNamed: spriteName)
        self.command = command
        super.init()
        self.addChild(self.sprite)
    }
    
    func removeFromParentWithDelay(delay: Double) {
        
        //@todo: may be make sence make it in animation editor?
        let animationDuration = GameConstants.BonusPickUpAnimationDuration
        let delayMove = SKAction.wait(forDuration: delay)
        let moveBy = SKAction.moveBy(x: 0.0, y: 20.0, duration: animationDuration)
        self.run(SKAction.sequence([delayMove, moveBy]))
        
        let delayScale = SKAction.wait(forDuration: delay + animationDuration * 0.5)
        let scaleIn = SKAction.scale(by: 1.5, duration: animationDuration * 0.5)
        scaleIn.timingMode = SKActionTimingMode.easeOut
        self.run(SKAction.sequence([delayScale, scaleIn]))
        
        let delayDelete = SKAction.wait(forDuration: delay + animationDuration)
        let delete = SKAction.perform(#selector(GameCell.removeFromParent), onTarget: self)
        self.run(SKAction.sequence([delayDelete, delete]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
