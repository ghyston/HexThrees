//
//  TutorialScene.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 26.03.19.
//  Copyright © 2019 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

class HelpMergingScene : SKScene, HelpScene {
 
    var swipeGestureNode : SwipeGestureNode?
    
    required init(frameSize : CGSize)  {
        
        super.init(size: frameSize)
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scaleMode = .resizeFill
        
        let hybridStartegy = MerginStrategyFabric.createByName(.Hybrid)
        hybridStartegy.prefilValues(maxIndex: 5)
        
        let model = GameModel(
            screenWidth: frameSize.width * 0.8,
            fieldSize: FieldSize.Quaddro.rawValue,
            strategy: hybridStartegy,
            motionBlur: false,
            hapticFeedback: false)
        
        var posY : CGFloat = frameSize.height / 2.0
        let startY = posY
        let mergingNodesFiboValues = [(0, 0), (0, 1), (1, 2), (2, 3)]
        let mergingNodesPow2Values = [(4, 4), (5, 5)]
        
        var pointsToPath = [CGPoint]()
        
        addMergingNodes(
            values: mergingNodesFiboValues,
            frameW: frameSize.width,
            model: model,
            path: &pointsToPath,
            posY: &posY)
        
        addLine(
            up: pointsToPath.first!,
            down: pointsToPath.last!,
            isArrow: false,
            text: "Fibonacci")
        
        posY -= 20
        
        addMergingNodes(
            values: mergingNodesPow2Values,
            frameW: frameSize.width,
            model: model,
            path: &pointsToPath,
            posY: &posY)
        
        addLine(
            up: pointsToPath.first!,
            down: pointsToPath.last!,
            isArrow: true,
            text: "Power of 2")
        
        posY = pointsToPath.last!.y
        posY -= 30
        
        self.swipeGestureNode = SwipeGestureNode(
            from: CGPoint(x: -frameSize.width/4, y: posY),
            to: CGPoint(x: frameSize.width/4, y: posY))
        self.swipeGestureNode?.repeatIndefinitely(
            startDelay: GameConstants.HelpVCAnimationDelay * 0.5,
            duration: GameConstants.HelpVCAnimationDelay,
            pause: GameConstants.HelpVCAnimationDelay * 1.5)
        
        addChild(self.swipeGestureNode!)
        
        adjustHeight(frameH: frameSize.height, sceneH: startY - posY)
    }
    
    private func adjustHeight(frameH : CGFloat, sceneH : CGFloat) {
        
        let offset = (frameH - sceneH ) / 2
        for child in children {
            child.position.y -= offset
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addMergingNodes(values: [(Int, Int)], frameW: CGFloat, model: GameModel, path: inout [CGPoint], posY: inout CGFloat) {
        
        path.removeAll()
        for valuePair in values {
            
            let mergeNode = HelpMergingNode(
                model: model,
                width: frameW * 0.7,
                valueLeft: valuePair.0,
                valueRight: valuePair.1)
            let mergeNodeSize = mergeNode.calculateAccumulatedFrame().size
            let halfW = mergeNodeSize.width / 2
            let halfH = mergeNodeSize.height / 2
            
            posY -= mergeNode.calculateAccumulatedFrame().size.height * 1.1
            path.append(CGPoint.init(x: -halfW, y: posY + halfH))
            path.append(CGPoint.init(x: -halfW, y: posY - halfH))
            mergeNode.position.x = 20
            mergeNode.position.y = posY
            addChild(mergeNode)
        }
    }
    
    private func addLine(up: CGPoint, down: CGPoint, isArrow: Bool, text: String) {
        
        let path = CGMutablePath.init()
        let fassetW : CGFloat = 20
        
        path.move(to: CGPoint(x: up.x + fassetW, y: up.y))
        path.addLine(to: up)
        path.addLine(to: down)
        
        if isArrow {
            path.addLine(to: CGPoint(x: down.x + fassetW / 2, y: down.y + fassetW / 2))
            path.move(to: CGPoint(x: down.x, y: down.y))
            path.addLine(to: CGPoint(x: down.x - fassetW / 2, y: down.y + fassetW / 2))
        } else {
            path.addLine(to: CGPoint(x: down.x + fassetW, y: down.y))
        }
        
        let line = SKShapeNode(path: path)
        line.strokeColor = .white
        addChild(line)
        
        let label = SKLabelNode(text: text)
        label.fontName = "Futura"
        label.fontSize = 12
        label.zRotation = 3.14 / 2
        label.position = CGPoint(x: (up.x + down.x) / CGFloat(2.0) - fassetW, y:(up.y + down.y) / CGFloat(2.0))
        addChild(label)
    }
    
    override func update(_ currentTime: TimeInterval) {
        self.swipeGestureNode?.update()
    }
}
