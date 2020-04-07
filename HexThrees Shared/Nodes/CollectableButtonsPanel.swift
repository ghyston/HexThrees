//
//  CollectableButtonsContainerNode.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 06.04.20.
//  Copyright © 2020 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

class CollectableButtonsPanel : SKNode {
	
	private let width: CGFloat
	private var buttons = [BonusType : CollectableBtn] ()
	
	init(width: CGFloat) {
		self.width = width
		super.init()
		
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
	
	func addButton(type: BonusType) {
		addButtonNode(type)
		moveButtons()
	}
	
	func addButtons(types: BonusType ... ) {
		for type in types {
			addButtonNode(type)
		}
		moveButtons()
	}
	
	func addButtonIfNotExist(type bonusType: BonusType) -> CollectableBtn {
		if let btn = buttons[bonusType] {
			return btn
		}
		addButton(type: bonusType)
		return buttons[bonusType]!
	}
	
	@objc func onCollectableUpdate(notification: Notification) {
		
		guard let bonusType = notification.object as? BonusType else {
			assert(true, "updateCollectables notification contain incorrect bonus type")
            return
        }
		
		let btn = addButtonIfNotExist(type: bonusType)
		btn.onCollectableUpdate(notification: notification)
	}
	
	 @objc func onCollectableUse(notification: Notification) {
		
		guard let bonusType = notification.object as? BonusType else {
			assert(true, "collectables use: notification contain incorrect bonus type")
            return
        }
		
		guard let button = buttons[bonusType] else {
			assert(true, "collectables use: button for bonus type is not found")
			return
		}
		
		button.playUseAnimation()
		buttons.removeValue(forKey: bonusType)
		
		let delay = SKAction.wait(forDuration: GameConstants.CollectableUpdateAnimationDuration)
		let moveDown = SKAction.move(
			to: CGPoint(
				x: button.position.x,
				y: -button.sprite.size.height),
			duration: GameConstants.CellAppearAnimationDuration
		);
		moveDown.timingMode = SKActionTimingMode.easeIn
		let delete = SKAction.perform(#selector(GameCell.removeFromParent), onTarget: button)
		
		button.run(SKAction.sequence([delay, moveDown, delete]))
		
		let moveButtonsDelay = SKAction.wait(forDuration: GameConstants.CollectableUpdateAnimationDuration)
		let moveRestButtons = SKAction.perform(#selector(CollectableButtonsPanel.moveButtons), onTarget: self)
        
        self.run(SKAction.sequence([moveButtonsDelay, moveRestButtons]))
	}
	
	private func addButtonNode(_ type: BonusType) {
		let button = CollectableBtn(type: type)
		button.zPosition = zPositions.bonusCollectable.rawValue
		button.position.y = button.sprite.size.height / 2.0
        button.position.x = width
		
		addChild(button)
		buttons[type] = button
	}
	
	@objc private func moveButtons() {
		let offset = self.width / CGFloat(buttons.count)
		var i : CGFloat = 0.0
		for btn in buttons {
			let action = SKAction.move(
				to: CGPoint(
					x: -self.width / 2.0 + offset * (i + 0.5),
					y: btn.value.sprite.size.height / 2),
				duration: GameConstants.CellAppearAnimationDuration
			);
			action.timingMode = SKActionTimingMode.easeIn
			btn.value.removeAllActions()
			btn.value.run(action)
			
			i += 1
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		 fatalError("init(coder:) has not been implemented")
	}
}
