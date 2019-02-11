//
//  BonusNode.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 27.08.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

class BonusNode : SKNode {
    
    private let sprite : SKSpriteNode
    private let circle : SKShapeNode
    private let countLabel : SKLabelNode
    let command : GameCMD
    var turnsCount : Int {
        didSet {
            updateLabelCount()
        }
    }
    let type: BonusType
    
    init(type: BonusType, spriteName: String, turnsToDispose: Int, onPick: GameCMD) {
        
        self.type = type
        
        self.sprite = SKSpriteNode(imageNamed: spriteName)
        self.command = onPick
        self.turnsCount = turnsToDispose
        
        //@todo: all labels should be created through fabric or by name from scenefile?
        self.countLabel = SKLabelNode()
        self.countLabel.fontSize = 12.0
        self.countLabel.fontName = "Chalkduster"
        self.countLabel.fontColor = .white //@todo: use palette manager
        self.countLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        
        let radius : CGFloat = 10.0
        self.circle = SKShapeNode(circleOfRadius: radius)
        self.circle.fillColor = .red //@todo: use palette manager
        self.circle.strokeColor = .red //@todo: use palette manager
        self.circle.position = CGPoint(
            x: Double((self.sprite.size.width - radius) / 2.0 ),
            y: Double((-self.sprite.size.height + radius) / 2.0))
        
        super.init()
        
        self.updateLabelCount()
        self.addChild(self.sprite)
        circle.addChild(self.countLabel)
        self.addChild(circle)
    }
    
    func playPickingAnimationAndRemoveFromParent(delay: Double) {
        
        let delayHide = SKAction.wait(forDuration: delay)
        let hide = SKAction.fadeAlpha(to: 0.0, duration: GameConstants.BonusAnimationDuration)
        self.circle.run(SKAction.sequence([delayHide, hide]))
        
        //@todo: may be make sence make it in animation editor?
        let animationDuration = GameConstants.BonusAnimationDuration
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
    
    func playDisposeAnimationAndRemoveFromParent() {
    
        let hide = SKAction.fadeAlpha(to: 0.0, duration: GameConstants.BonusAnimationDuration)
        let delete = SKAction.perform(#selector(GameCell.removeFromParent), onTarget: self)
        self.run(SKAction.sequence([hide, delete]))
    }
    
    func decCount() -> Bool {
        
        self.turnsCount -= 1
        self.updateLabelCount()
        return self.turnsCount == 0
    }
    
    private func updateLabelCount() {
        
        self.countLabel.text = "\(self.turnsCount)"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
