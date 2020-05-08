//
//  GameScene.swift
//  HexThrees Shared
//
//  Created by Ilja Stepanow on 10.04.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
	var prevInterval: TimeInterval?
	var panel: CollectableButtonsPanel?
	var shaderManager: IShaderManager?
	
	override init(size: CGSize) {
		super.init(size: size)
		print("GameScene::init size:\(size)")
		
		anchorPoint.x = 0.5
		anchorPoint.y = 0.5
		self.scaleMode = .resizeFill
		
		let buttons = CollectableButtonsPanel(width: size.width)
		buttons.position.y = -size.height / 2.0 + 3.0
		addChild(buttons)
		
		self.panel = buttons
	}
	
	private var fieldOutline: FieldOutline {
		let existingBg = childNode(withName: FieldOutline.defaultNodeName)
		let fieldBg = existingBg as? FieldOutline ?? FieldOutline()
		if existingBg == nil {
			fieldBg.name = FieldOutline.defaultNodeName
			addChild(fieldBg)
		}
		return fieldBg
	}
	
	func addFieldOutlineCell(where coords: AxialCoord, startPos: CGPoint, color: SKColor, using geometry: FieldGeometry) {
		fieldOutline.addFieldOutlineCell(where: coords, startPos: startPos, color: color, using: geometry)
	}
	
	func addFieldOutline(_ model: GameModel) {
		fieldOutline.recalculateFieldBg(model: model)
	}
	
	func scaleFieldOutline(by scale: CGFloat, _ model: GameModel) {
		fieldOutline.updateGeometry(by: scale, using: model.geometry!)
	}
	
	override func didMove(to view: SKView) {}
	
	public func updateSafeArea(bounds: CGRect, insects: UIEdgeInsets) {
		panel?.position.y = -size.height / 2.0 + insects.bottom
	}
	
	override func update(_ currentTime: TimeInterval) {
		if prevInterval == nil {
			prevInterval = currentTime
		}
		
		let delta = currentTime - prevInterval!
		prevInterval = currentTime
		
		shaderManager?.updateSelectableAnimation(delta)
		
		let updateNode: (_: SKNode) -> Void = {
			($0 as? MotionBlurNode)?.updateMotionBlur(delta)
			($0 as? AnimatedNode)?.updateAnimation(delta)
		}
		
		runForAllSubnodes(lambda: updateNode)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
