//
//  BonusableNode.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 04.12.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

protocol BonusableNode : class {
    
    var bonus: BonusNode? { get set }
    
    func addBonus(_ bonusNode: BonusNode)
    func removeBonusWithDisposeAnimation()
    func removeBonusWithPickingAnimation(_ delay: Double)
}

extension BonusableNode where Self : SKNode {
    
    func addBonus(_ bonusNode: BonusNode) {
        
        self.bonus = bonusNode
        self.bonus?.zPosition = zPositions.bonusZ.rawValue
        addChild(self.bonus!)
    }
    
    func removeBonusWithDisposeAnimation() {
        
        self.bonus?.playDisposeAnimationAndRemoveFromParent()
        self.bonus = nil
    }
    
    func removeBonusWithPickingAnimation(_ delay: Double) {
        
        self.bonus?.playPickingAnimationAndRemoveFromParent(delay: delay)
        self.bonus = nil
    }
}
