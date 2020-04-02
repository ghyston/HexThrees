//
//  CollectableBtn.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 16.09.19.
//  Copyright © 2019 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

class CollectableBtn : SKNode, AnimatedNode {
    
    private let shader : AnimatedShaderNode
    private var playback: IPlayback?
    
    let sprite : SKSpriteNode
    let type: BonusType
    lazy var gameModel : GameModel = ContainerConfig.instance.resolve()
    
    init(type: BonusType) {
        self.type = type
        let spriteName = BonusFabric.spriteName(bonus: type)
        self.sprite = SKSpriteNode.init(imageNamed: spriteName)
        self.shader = AnimatedShaderNode(fileNamed: "collectableButton")
        self.sprite.shader = self.shader
        super.init()
        addChild(self.sprite)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onCollectableUpdate),
            name: .updateCollectables,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onCollectableUse),
            name: .useCollectables,
            object: nil)
    }
    
    func updateAnimation(_ delta: TimeInterval) {
        if let playbackValue = self.playback?.update(delta: delta) {
            self.shader.update(playbackValue)
        }
    }
    
    @objc func onCollectableUpdate(notification: Notification) {
        if notification.object as? BonusType != self.type {
            return
        }
        
        guard let collectable = self.gameModel.collectableBonuses[self.type] else {
            return
        }
        
        let step = 1.0 / Double(collectable.maxValue)
        let start = Double(collectable.currentValue - 1) * step
        
        self.playback = Playback()
        self.playback?.setRange(
            from: start,
            to: start + step)
        self.playback?.start(
            duration: 1.0, //@todo: duration hardcoded!
            reversed: false,
            repeated: false,
            onFinish: self.removeAnimation)
    }
    
    @objc func onCollectableUse(notification: Notification) {
        if notification.object as? BonusType != self.type {
            return
        }
        
        guard let collectable = self.gameModel.collectableBonuses[self.type] else {
            return
        }
        
        self.playback = Playback()
        self.playback?.setRange(
            from: Double(collectable.maxValue),
            to: 0.0)
        self.playback?.start(
            duration: 1.0, //@todo: duration hardcoded!
            reversed: false,
            repeated: false,
            onFinish: self.removeAnimation)
    }
    
    @objc private func removeAnimation() {
        self.playback = nil
    }
    
    func onClick() {
		if self.gameModel.selectedBonusType != nil {
			return
		}
		
        if self.gameModel.collectableBonuses[self.type]?.isFull == true {
            
            if let collectableBonus = BonusFabric.collectableSelectableBonusCMD(bonus: self.type, gameModel: self.gameModel) {
				self.gameModel.selectedBonusType = self.type
				StartCellSelectionCMD(gameModel)
					.run(comparator: collectableBonus.comparator,
						 onSelectCmd: collectableBonus.cmd)
			} else if let bonusCmd = BonusFabric.collectableNotSelectableBonusCMD(bonus: self.type, gameModel: self.gameModel) {
				bonusCmd.run()
				self.gameModel.collectableBonuses[self.type]?.use()
			}
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
