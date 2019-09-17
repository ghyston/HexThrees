//
//  CollectableBtn.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 16.09.19.
//  Copyright © 2019 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

class CollectableBtn : SKNode {
    
    let sprite : SKSpriteNode
    let type: BonusType
    lazy var gameModel : GameModel = ContainerConfig.instance.resolve()
    
    init(type: BonusType) {
        self.type = type
        let spriteName = BonusFabric.spriteName(bonus: type)
        self.sprite = SKSpriteNode.init(imageNamed: spriteName)
        super.init()
        addChild(self.sprite)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onCollectableUpdate),
            name: .updateCollectables,
            object: nil)
    }
    
    @objc func onCollectableUpdate(notification: Notification) {
        if notification.object as? BonusType != self.type {
            return
        }
        
        //@todo: play animation
    }
    
    func onClick() {
        if self.gameModel.collectableBonuses[self.type]?.isFull == true {
            BonusFabric.collectableAction(
                bonus: self.type,
                gameModel: self.gameModel)?
                .run()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
