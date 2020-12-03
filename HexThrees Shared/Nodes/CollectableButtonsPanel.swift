//
//  CollectableButtonsContainerNode.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 06.04.20.
//  Copyright © 2020 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

class CollectableButtonsPanel: SKNode {
	private let width: CGFloat
	private var buttons = [BonusType: CollectableBtn]()
	private var buttonsOrder = [BonusType]()
	
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
	
	public func removeAllButtons() {
		for btn in buttons {
			removeButton(btn.value, btn.key)
		}
	}
	
	private func addButton(type: BonusType) {
		addButtonNode(type)
		moveButtons()
	}
	
	private func addButtons(types: BonusType ...) {
		for type in types {
			addButtonNode(type)
		}
		moveButtons()
	}
	
	private func addButtonIfNotExist(type bonusType: BonusType) -> CollectableBtn {
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
		
		removeButton(button, bonusType)
	}
	
	private func removeButton(_ button: CollectableBtn, _ bonusType: BonusType) {
		button.playUseAnimation()
		buttons.removeValue(forKey: bonusType)
		buttonsOrder.removeAll(where: { $0 == bonusType })
		
		let delay = SKAction.wait(forDuration: GameConstants.CollectableUpdateAnimationDuration)
		let moveDown = SKAction.move(
			to: CGPoint(
				x: button.position.x,
				y: -button.sprite.size.height),
			duration: GameConstants.CellAppearAnimationDuration)
		moveDown.timingMode = SKActionTimingMode.easeIn
		let delete = SKAction.perform(#selector(GameCell.removeFromParent), onTarget: button)
		
		button.run(SKAction.sequence([delay, moveDown, delete]))
		
		let moveButtonsDelay = SKAction.wait(forDuration: GameConstants.CollectableUpdateAnimationDuration)
		let moveRestButtons = SKAction.perform(#selector(CollectableButtonsPanel.moveButtons), onTarget: self)
		
		run(SKAction.sequence([moveButtonsDelay, moveRestButtons]))
	}
	
	private func addButtonNode(_ type: BonusType) {
		let button = CollectableBtn(type: type)
		button.zPosition = zPositions.bonusCollectable.rawValue
		button.position.y = button.sprite.size.height / 2.0
		button.position.x = width
		
		addChild(button)
		buttons[type] = button
		buttonsOrder.append(type)
	}
	
	@objc private func moveButtons() {
		let offset = width / CGFloat(buttons.count)
		var i: CGFloat = 0.0
		for btnType in buttonsOrder {
			guard let btn = buttons[btnType] else {
				continue
			}
			let action = SKAction.move(
				to: CGPoint(
					x: -width / 2.0 + offset * (i + 0.5),
					y: btn.sprite.size.height / 2),
				duration: GameConstants.CellAppearAnimationDuration)
			action.timingMode = SKActionTimingMode.easeIn
			btn.removeAllActions()
			btn.run(action)
			
			i += 1
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
