//
//  TutorialScene.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 26.03.19.
//  Copyright © 2019 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

class TutorialScene : SKScene {
 
    class func create(frameSize : CGSize) -> TutorialScene {
        
        let scene = TutorialScene(size: CGSize(width: 1200, height: 1200))
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        scene.scaleMode = .resizeFill
        
        let hybridStartegy = MerginStrategyFabric.createByName(.Hybrid)
        hybridStartegy.prefilValues(maxIndex: 5)
        
        let model = GameModel(
            screenWidth: frameSize.width * 0.9,
            fieldSize: FieldSize.Quaddro.rawValue,
            strategy: hybridStartegy,
            motionBlur: false,
            hapticFeedback: false)
        
        var posY : CGFloat = frameSize.height / 2.0
        let mergingNodesFiboValues = [(0, 0), (0, 1), (1, 2), (2, 3)]
        let mergingNodesPow2Values = [(4, 4), (5, 5)]
        
        var pointsToPath = [CGPoint]()
        
        scene.addMergingNodes(
            values: mergingNodesFiboValues,
            frameW: frameSize.width,
            model: model,
            path: &pointsToPath,
            posY: &posY)
        
        scene.addLine(
            up: pointsToPath.first!,
            down: pointsToPath.last!,
            isArrow: false,
            text: "Fibonacci")
        
        posY -= 20
        
        scene.addMergingNodes(
            values: mergingNodesPow2Values,
            frameW: frameSize.width,
            model: model,
            path: &pointsToPath,
            posY: &posY)
        
        scene.addLine(
            up: pointsToPath.first!,
            down: pointsToPath.last!,
            isArrow: true,
            text: "Power of 2")
        
        return scene
    }
    
    private func addMergingNodes(values: [(Int, Int)], frameW: CGFloat, model: GameModel, path: inout [CGPoint], posY: inout CGFloat) {
        
        path.removeAll()
        for valuePair in values {
            
            let mergeNode = TutorialMergingNode(
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
}
