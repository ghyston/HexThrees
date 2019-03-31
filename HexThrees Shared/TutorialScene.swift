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
            screenWidth: frameSize.width,
            fieldSize: FieldSize.Quaddro.rawValue,
            strategy: hybridStartegy,
            motionBlur: false,
            hapticFeedback: false)
        
        var posY : CGFloat = frameSize.height / 2.0
        let mergingNodesValues = [(0, 0), (0, 1), (1, 2), (2, 3), (4, 4), (5, 5)]
        
        for valuePair in mergingNodesValues {
            
            let mergeNode = TutorialMergingNode(
                model: model,
                width: frameSize.width * 0.7,
                valueLeft: valuePair.0,
                valueRight: valuePair.1)
            posY -= mergeNode.calculateAccumulatedFrame().size.height * 1.1
            mergeNode.position.x = 20
            mergeNode.position.y = posY
            scene.addChild(mergeNode)
        }
        
        
        
        return scene
    }
}
