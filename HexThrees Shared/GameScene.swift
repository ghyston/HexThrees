//
//  GameScene.swift
//  HexThrees Shared
//
//  Created by Ilja Stepanow on 10.04.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var prevInterval : TimeInterval?
	let bikeStar : SKSpriteNode
    
    override init(size: CGSize) {
		
		self.bikeStar = SKSpriteNode.init(imageNamed: "bikeStar")
		
        super.init(size: size)
        
        self.anchorPoint.x = 0.5
        self.anchorPoint.y = 0.5
        self.scaleMode = .resizeFill
        addCollectableButtons()
		
		//@todo: all of this for test
		self.bikeStar.xScale = 1.5
		self.bikeStar.yScale = 1.5
		self.bikeStar.colorBlendFactor = 1.0
		self.bikeStar.color = .darkGray
		self.addChild(self.bikeStar)
		
		createGear()
    }
	
	func createGear() {
		let hexShape = SKShapeNode()
		hexShape.path = FieldGeometry.createGearPath(
			radIn: 70, radOut: 100, count: 8)
		hexShape.fillColor = .red
		hexShape.position.y = -200
		hexShape.position.x = -200
		 
        addChild(hexShape)
	}
	
	func runCircles(angle: CGFloat, duration: TimeInterval) {
		let rotateAction = SKAction.rotate(byAngle: angle, duration: duration)
		rotateAction.timingMode = SKActionTimingMode.easeInEaseOut
		self.bikeStar.run(rotateAction)
	}
    
    func addCollectableButtons() {
        
        let offset: CGFloat = 3.0
        
        let collectableBonusBtn1 = CollectableBtn(type: .COLLECTABLE_TYPE_1)
        let btnSize1 = collectableBonusBtn1.sprite.size
        collectableBonusBtn1.position.y = -size.height / 2.0 + btnSize1.height / 2.0 + offset
        collectableBonusBtn1.position.x = size.width / 2.0 - btnSize1.width / 2.0 - offset
        collectableBonusBtn1.zPosition = zPositions.bonusCollectable.rawValue
        addChild(collectableBonusBtn1)
        
        let collectableBonusBtn2 = CollectableBtn(type: .COLLECTABLE_TYPE_2)
        let btnSize2 = collectableBonusBtn2.sprite.size
        collectableBonusBtn2.position.y = -size.height / 2.0 + btnSize2.height / 2.0 + offset
        collectableBonusBtn2.position.x = -size.width / 2.0 + btnSize2.width / 2.0 + offset
        collectableBonusBtn2.zPosition = zPositions.bonusCollectable.rawValue
        addChild(collectableBonusBtn2)
    }
    
    func addFieldOutline(_ model: GameModel) {
        
        let existingBg = childNode(withName: FieldOutline.defaultNodeName)
        let fieldBg = existingBg as? FieldOutline ?? FieldOutline()
        if existingBg == nil {
            fieldBg.name = FieldOutline.defaultNodeName
            addChild(fieldBg)
        }
        
        fieldBg.recalculateFieldBg(model: model)
    }
    
    //@note: run it after everything is initialised
    func addTestNode() {
        let shape = SKShapeNode.init(rectOf: CGSize(width: 200, height: 200))
        
        let testingNode = BgCell(hexShape: shape, blocked: false, coord: AxialCoord(0,0))
        testingNode.position.y = -size.height / 4
        testingNode.zPosition = zPositions.testShadersNode.rawValue
        addChild(testingNode)
        testingNode.block()
    }
    
    override func didMove(to view: SKView) {
        
    }
    
    public func updateSafeArea(bounds: CGRect, insects: UIEdgeInsets) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if prevInterval == nil {
            prevInterval = currentTime
        }
        
        let delta = currentTime - prevInterval!
        prevInterval = currentTime
        
        let updateNode : (_: SKNode) -> Void = {
            ($0 as? MotionBlurNode)?.updateMotionBlur(delta)
            ($0 as? AnimatedNode)?.updateAnimation(delta)
        }
        
        runForAllSubnodes(lambda: updateNode)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
