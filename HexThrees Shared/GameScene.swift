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
    var timerNode: TimerNode
    
    override init(size: CGSize) {
        
        self.timerNode = TimerNode(
            period: 3,
            width: size.width)
        
        super.init(size: size)
        
        self.anchorPoint.x = 0.5
        self.anchorPoint.y = 0.5
        self.scaleMode = .resizeFill
        
        timerNode.zPosition = zPositions.timerBar.rawValue
        
        timerNode.position.y = -size.height / 2 + 7
        addChild(timerNode)
    }
    
    override func didMove(to view: SKView) {
        
    }
    
    public func updateSafeArea(bounds: CGRect, insects: UIEdgeInsets) {
        timerNode.position.y = -bounds.height / 2 + insects.bottom / 2 + 7
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if prevInterval == nil {
            prevInterval = currentTime
        }
        
        let delta = currentTime - prevInterval!
        prevInterval = currentTime
        
        //@todo: uglyuglyuglyuglyuglyuglyuglyuglyugly
        //@todo: use runForAllSubnodes
        for firstLevelChild in self.children {
            for secondLevel in firstLevelChild.children where secondLevel is MotionBlurNode  {
                (secondLevel as! MotionBlurNode).updateMotionBlur(delta)
            }
        }
        
        timerNode.update(delta)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
