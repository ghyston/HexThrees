//
//  TutorialSwipeScene.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 04.04.19.
//  Copyright © 2019 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

class HelpSwipeScene : SKScene, HelpScene {
    
    let model : GameModel
    weak var swipeGestureNode : SwipeGestureNode?
    var swipeNodeBoundaries = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    required init(frameSize : CGSize) {
        
        self.model = GameModel(
            screenWidth: frameSize.width * 0.9,
            fieldSize: FieldSize.Quaddro.rawValue,
            strategy: MerginStrategyFabric.createByName(.Tutorial),
            motionBlur: false,
            hapticFeedback: false,
            timerEnabled: false)
        
        super.init(size: CGSize(width: 1200, height: 1200))
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scaleMode = .resizeFill
        
        let node = HelpSwipeNode(
            model: self.model,
            width: frameSize.width,
            scene: self)
        swipeNodeBoundaries = node.calculateAccumulatedFrame()
        addChild(node)
        
        startAnimation()
    }
    
    private func startAnimation() {
        
        let startDelay = SKAction.wait(forDuration: GameConstants.HelpVCAnimationDelay)
        let animation = SKAction.perform(#selector(HelpSwipeScene.doRandomSwipe), onTarget: self)
        let sequence = SKAction.sequence([startDelay, animation])
        let repeatAction = SKAction.repeatForever(sequence)
        self.run(repeatAction)
    }
    
    @objc private func doRandomSwipe() {
        
        var allDirections = SwipeDirection.allCases.shuffled()
        
        while !allDirections.isEmpty {
            let direction = allDirections.popLast()!
            guard let iterator = IteratorFabric.create(self.model, direction) else {
                continue
            }
            
            while let line = iterator.next() {
                if(line.check(strategy: self.model.strategy)) {
                    DoSwipeCMD(self.model).run(direction: direction.inverse())
                    showSwipeGestureNode(direction.inverse())
                    return
                }
            }
        }
    }
    
    private func showSwipeGestureNode(_ direction: SwipeDirection) {
        
        let swipeLen : Double = 200
        let offset : CGFloat  = 25
        
        var dir : CGPoint //direction
        var pos: CGPoint //position
        let rnd = Bool.random()
        
        switch direction {
        case .Left:
            dir = CGPoint(x: -swipeLen * 1.4, y: 0)
            pos = CGPoint(
                x: swipeNodeBoundaries.maxX,
                y: rnd ?
                    swipeNodeBoundaries.minY - offset :
                    swipeNodeBoundaries.maxY + offset
            )
        case .Right:
            dir = CGPoint(x: swipeLen * 1.4, y: 0)
            pos = CGPoint(
                x: swipeNodeBoundaries.minX,
                y: rnd ?
                    swipeNodeBoundaries.maxY + offset :
                    swipeNodeBoundaries.minY - offset)
        case .XUp:
            dir = CGPoint(x: swipeLen, y: swipeLen * 1.732)
            pos = CGPoint(
                x: rnd ?
                    offset * 2 :
                    swipeNodeBoundaries.minX - offset,
                y: rnd ?
                    swipeNodeBoundaries.minY :
                    0
            )
        case .XDown:
            dir = CGPoint(x: -swipeLen, y: -swipeLen * 1.732)
            pos = CGPoint(
                x: rnd ?
                    swipeNodeBoundaries.maxX + offset :
                    0,
                y: rnd ?
                    0 :
                    swipeNodeBoundaries.maxY + offset * 2)
        case .YUp:
            dir = CGPoint(x: -swipeLen, y: swipeLen * 1.732)
            pos = CGPoint(
                x: rnd ?
                    -offset * 2 :
                    swipeNodeBoundaries.maxX + offset,
                y: rnd ?
                swipeNodeBoundaries.minY - offset :
                0)
        case .YDown:
            dir = CGPoint(x: swipeLen, y: -swipeLen * 1.732)
            pos = CGPoint(
                x: rnd ?
                    swipeNodeBoundaries.minX - offset :
                    offset,
                y: rnd ?
                    0 :
                    swipeNodeBoundaries.maxY + offset
            )
        default:
            dir = CGPoint(x: 0, y: 0)
            pos = CGPoint(x: 0, y: 0)
        }
        
        let node = SwipeGestureNode(from: CGPoint(x: 0, y: 0), to:  dir)
        node.position = pos
        addChild(node)
        node.zPosition = zPositions.helpGesture.rawValue
        node.playOnce(
            startDelay: 0,
            duration: GameConstants.SecondsPerCell * 4)
        self.swipeGestureNode = node
    }
    
    override func update(_ currentTime: TimeInterval) {
        self.swipeGestureNode?.update()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
