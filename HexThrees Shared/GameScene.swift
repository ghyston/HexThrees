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
    
    override init(size: CGSize) {
        super.init(size: size)
        
        self.anchorPoint.x = 0.5
        self.anchorPoint.y = 0.5
        self.scaleMode = .resizeFill
        addCollectableButtons()
    }
    
    func addCollectableButtons() {
        let collectableBonusBtn = CollectableBtn(type: .COLLECTABLE_TYPE_1)
        let btnSize = collectableBonusBtn.sprite.size
        let offset: CGFloat = 3.0
        collectableBonusBtn.position.y = -size.height / 2.0 + btnSize.height / 2.0 + offset
        collectableBonusBtn.position.x = size.width / 2.0 - btnSize.width / 2.0 - offset
        collectableBonusBtn.zPosition = zPositions.bonusCollectable.rawValue
        addChild(collectableBonusBtn)
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
            ($0 as? BlockableNode)?.updateAnimation(delta)
        }
        
        runForAllSubnodes(lambda: updateNode)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
