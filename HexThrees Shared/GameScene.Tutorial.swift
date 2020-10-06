//
//  GameScene.Tutorial.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 25.05.20.
//  Copyright © 2020 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

extension GameScene {
	public func addCallbacks() {
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(onAddHighlightCircle),
			name: .addSceneHighlight,
			object: nil)
		
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(onResetHighlight),
			name: .resetSceneHighlight,
			object: nil)
		
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(onMoveHighlightCircle),
			name: .moveSceneHighlight,
			object: nil)
		
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(onUpdateDescription),
			name: .updateSceneDescription,
			object: nil)
		
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(onCleanScene),
			name: .cleanTutorialScene,
			object: nil)
		
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(onRemoveHighlight),
			name: .removeSceneHighlight,
			object: nil)
		
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(onCreateGrayLayer),
			name: .createTutorialGrayLayer,
			object: nil)
	}
	
	struct HighlightCircleDto {
		let coord: CGPoint
		let rad: CGFloat
		let delay: Double?
		let name: TutorialNodeNames
	}
	
	enum TextDescriptionPos {
		case Top
		case Bottom
	}
	
	struct TextDescriptionDto {
		let text: String?
		let attrText: NSMutableAttributedString?
		let yPos: TextDescriptionPos
		let pulsing: Bool
	}
	
	@objc func onAddHighlightCircle(notification: Notification) {
		guard let highlightCircleDtos = notification.object as? [HighlightCircleDto] else {
			return
		}
		
		for dto in highlightCircleDtos {
			addHighlightCircle(
				where: dto.coord,
				radius: dto.rad,
				name: dto.name.rawValue,
				delay: dto.delay ?? 0.0)
		}
	}
	
	@objc func onMoveHighlightCircle(notification: Notification) {
		guard let dto = notification.object as? HighlightCircleDto else {
			return
		}
		
		moveHighlightCircle(
			to: dto.coord,
			name: dto.name.rawValue)
	}
	
	@objc func onCreateGrayLayer(notification: Notification){
		createGreyLayer()
	}
	
	@objc func onResetHighlight(notification: Notification) {
		removeAllHighlightCircles()
	}
	
	@objc func onRemoveHighlight(notification: Notification) {
		guard let nodeName = notification.object as? TutorialNodeNames else {
			return
		}
		
		shrinkAndRemoveHighlight(name: nodeName.rawValue)
	}
	
	@objc func onUpdateDescription(notification: Notification) {
		if let descriptionDto = notification.object as? TextDescriptionDto {
			addDescription(textDto: descriptionDto)
		}
		else if let description = notification.object as? String {
			addDescription(textDto: TextDescriptionDto(text: description, attrText: nil, yPos: .Bottom, pulsing: false))
		}
	}
	
	@objc func onCleanScene(notification: Notification) {
		removeAllHighlightCircles()
		prepareLabel()?.removeFromParentWithDelay(delay: GameConstants.CellAppearAnimationDuration)
		removeOldLabelBg()
		run(SKAction.sequence([
			SKAction.wait(forDuration: GameConstants.TutorialTextAppearDuration), // gray layer needs to be removed before all circles will dissapear
			SKAction.run { self.removeGreyLayer() }
		]))
	}
	
	private func addHighlightCircle(where coord: CGPoint, radius: CGFloat, name: String, delay: TimeInterval) {
		let isFirst = greyLayer == nil
		
		createGreyLayer()
		
		let circleShape = SKShapeNode(circleOfRadius: radius)
		circleShape.fillColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
		circleShape.lineWidth = 0.0
		circleShape.position = coord
		circleShape.name = name
		greyLayer?.addChild(circleShape)
		
		let scale: CGFloat = isFirst ? 5.0 : 0.01
		
		circleShape.xScale = scale
		circleShape.yScale = scale
		
		let delayAction = SKAction.wait(forDuration: delay)
		let scaleAction = SKAction
			.scale(to: 1.0, duration: GameConstants.TutorialNodesAppearDuration)
			.with(mode: .easeOut)
		
		circleShape
			.run(SKAction.sequence([delayAction, scaleAction]))
	}
	
	private func moveHighlightCircle(to coord: CGPoint, name: String) {
		greyLayer?
			.childNode(withName: name)?
			.run(SKAction.move(
				to: coord,
				duration: GameConstants.TutorialNodesAppearDuration)
				.with(mode: .easeOut))
	}
	
	private func removeAllHighlightCircles() {
		guard let greyLayer = greyLayer else {
			assert(false, "Grey layer not exist")
			return
		}
		
		for child in greyLayer.children {
			let removeAction = SKAction.perform(#selector(SKNode.removeFromParent), onTarget: child)
			let scaleAction = SKAction.scale(to: 5.0, duration: GameConstants.TutorialTextAppearDuration).with(mode: .easeOut)
			child.run(SKAction.sequence([scaleAction, removeAction]))
		}
	}
	
	private func shrinkAndRemoveHighlight(name: String) {
		guard let node = greyLayer?.childNode(withName: name) else {
			return
		}
		
		let removeAction = SKAction.perform(#selector(SKNode.removeFromParent), onTarget: node)
		let scaleAction = SKAction.scale(to: 0.01, duration: GameConstants.TutorialTextAppearDuration).with(mode: .easeOut)
		node.run(SKAction.sequence([scaleAction, removeAction]))
	}
	
	private func createGreyLayer() {
		if greyLayer != nil {
			return
		}
		
		let greyLayer = SKSpriteNode(color: UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0), size: size)
		
		let overlay = SKSpriteNode(color: .black, size: size) // SK bug: if SKSpriteNode is created wo texture, it can not be set afterwards
		overlay.zPosition = zPositions.tutorialHighlight.rawValue
		overlay.shader = SKShader(fileNamed: "tutorialHighlight")
		addChild(overlay)
		
		self.overlay = overlay
		self.greyLayer = greyLayer
		
		addChild(greyLayer)
		greyLayer.position = CGPoint(x: -10000.0, y: 0.0) // Hack: if node is not added to scene, then zooming actions will stall
	}
	
	private func removeGreyLayer() {
		greyLayer?.removeFromParent()
		overlay?.removeFromParent()
		greyLayer = nil
		overlay = nil
	}
	
	public func drawOverlay() {
		guard let overlay = self.overlay,
			let greyLayer = greyLayer else {
			return
		}
		
		overlay.texture = view?.texture(
			from: greyLayer,
			crop: CGRect(
				origin: CGPoint(x: -size.width / 2.0 - 10000.0, y: -size.height / 2.0),
				size: size))
	}
	
	private func addDescription(textDto: TextDescriptionDto) {
		removeOldLabelBg()
		let label = prepareLabel() ?? createLabel()
		
		var yPos : CGFloat {
			switch textDto.yPos {
			case .Bottom:
				return -size.height / 2.5
			case .Top:
				return size.height / 4.0
			}
		}
		
		var actions = [
			SKAction.run { label.position.y = yPos },
			SKAction.run {
				label.attributedText = textDto.attrText
				label.text = textDto.text
				
				self.createLabelBg(label: label, yPos: yPos) //@todo: memleak?
			},
			SKAction.fadeIn(withDuration: GameConstants.TutorialTextAppearDuration)
		]
		
		if label.hasActions() {
			actions.insert(SKAction.wait(forDuration: GameConstants.TutorialTextAppearDuration), at: 0)
		}
		
		label.run(SKAction.sequence(actions))
		
		label.removeAction(forKey: TutorialNodeNames.PulsingActionName.rawValue)
		if textDto.pulsing {
			let delta = 0.07
			let zoomIn = SKAction.scale(to: CGFloat(1.0 + delta), duration: 2.0)
			let zoomOut = SKAction.scale(to: CGFloat(1.0 - delta), duration: 2.0)
			let foreva = SKAction.repeatForever(SKAction.sequence([zoomIn, zoomOut]))
			label.run(foreva, withKey: TutorialNodeNames.PulsingActionName.rawValue)
		}
	}
	
	private func removeOldLabelBg() {
		guard let labelBg = childNode(withName: TutorialNodeNames.DescriptionBg.rawValue) as? SKShapeNode else {
			return
		}
		
		labelBg.removeAllActions()
		labelBg.run(SKAction.fadeOut(withDuration: GameConstants.TutorialTextAppearDuration))
		labelBg.removeFromParentWithDelay(delay: GameConstants.TutorialTextAppearDuration)
		labelBg.name = nil
		removeOldLabelBg() // make it recursive in case that there are more than one bg label
	}
	
	private func prepareLabel() -> SKLabelNode? {
		guard let label = childNode(withName: TutorialNodeNames.Description.rawValue) as? SKLabelNode else {
			return nil
		}
		label.run(SKAction.fadeOut(withDuration: GameConstants.TutorialTextAppearDuration))
		
		return label
	}
	
	private func createLabelBg(label: SKLabelNode, yPos: CGFloat) {
		let frameoverlap : CGFloat = 1.1
		let newBg = SKShapeNode(
			rectOf: CGSize(
				width: frameoverlap * label.frame.width,
				height: frameoverlap * label.frame.height),
			cornerRadius: 10.0)
		newBg.name = TutorialNodeNames.DescriptionBg.rawValue
		newBg.zPosition = zPositions.tutorialDescriptionBg.rawValue
		newBg.position.y = yPos + label.frame.height * 0.5
		newBg.fillColor = UIColor(white: 0.5, alpha: 0.65)
		newBg.lineWidth = 0.0
		newBg.alpha = 0.0
		newBg.run(SKAction.fadeIn(withDuration: GameConstants.TutorialTextAppearDuration))
		
		addChild(newBg)
	}
	
	private func createLabel() -> SKLabelNode {
		let label = SKLabelNode(fontNamed: "Futura Medium")
		label.fontSize = 35
		
		label.fontColor = SKColor(rgb: 0xECB235)
		label.zPosition = zPositions.tutorialDescription.rawValue
		label.name = TutorialNodeNames.Description.rawValue
		
		label.alpha = 0.0
		label.numberOfLines = 2
		
		addChild(label)
		return label
	}
	
	private func removeDescription() {}
}
