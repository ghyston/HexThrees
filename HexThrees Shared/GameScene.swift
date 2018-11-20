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
        
        /*let fShader = SKShader.init(fileNamed: "gridDervative.fsh")
        let circle = SKShapeNode.init(circleOfRadius: 150)
        let hexTexture = SKTexture.init(imageNamed: "hex")
        
        //circle.fillTexture = hexTexture
        circle.fillShader = fShader
        circle.zPosition = 20
        circle.position.y = 200
        scene.addChild(circle)*/
        
        return scene
    }
    
    override func didMove(to view: SKView) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        for node in self.children where node is GameCell
        {
            (node as! HexCell).updateMotionBlur()
        }
    }
}
