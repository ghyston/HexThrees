//
//  GameScene.swift
//  HexThrees Shared
//
//  Created by Ilja Stepanow on 10.04.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    class func newGameScene() -> GameScene {
        
        guard let scene = SKScene(fileNamed: "GameScene") as? GameScene else {
            print("Failed to load GameScene.sks")
            abort()
        }
        
        scene.scaleMode = .resizeFill
        
        let motionBlurHolder = SKEffectNode.init();
        let fShader = SKShader.init(fileNamed: "blur.fsh")
        let sprite = SKSpriteNode.init(imageNamed: "fucking_cat")
        let circle = SKShapeNode.init(circleOfRadius: 150)
        
        circle.fillColor = .red
        motionBlurHolder.shader = fShader
        motionBlurHolder.zPosition = 20
        
        motionBlurHolder.addChild(circle)
        motionBlurHolder.addChild(sprite)
        scene.addChild(motionBlurHolder)
        
        return scene
    }
    
    override func didMove(to view: SKView) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
}
