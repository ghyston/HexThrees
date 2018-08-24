//
//  GameScene.swift
//  HexThrees Shared
//
//  Created by Ilja Stepanow on 10.04.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var selfRenderTextureNode = SKSpriteNode()
    var cropRect : CGRect?
    
    class func newGameScene() -> GameScene {
        
        guard let scene = SKScene(fileNamed: "GameScene") as? GameScene else {
            print("Failed to load GameScene.sks")
            abort()
        }
        
        scene.scaleMode = .resizeFill
        
        scene.addChild(scene.setupEffectNoteForTest())
        
        return scene
    }
    
    func setupEffectNoteForTest() -> SKNode {
        
        let count : Float = 10.0
        let sum : Float = count * (count + 1.0) / 2.0
        let speed : Float = 0.5
        
        let motionBlurHolder = SKEffectNode.init();
        let fShader = SKShader.init(fileNamed: "blur.fsh")
        let sprite = SKSpriteNode.init(imageNamed: "fucking_cat")
        let circle = SKShapeNode.init(circleOfRadius: 150)
        
        let countUniform = SKUniform.init(name: "COUNT", float: count);
        let sumUniform = SKUniform.init(name: "SUM", float: sum);
        fShader.addUniform(countUniform);
        fShader.addUniform(sumUniform);
        
        let speedAttr = SKAttribute.init(
            name: "SPEED", type: .float)
        fShader.attributes.append(speedAttr)
        motionBlurHolder.setValue(SKAttributeValue(float: speed), forAttribute: "SPEED");
        
        circle.fillColor = .red
        motionBlurHolder.shader = fShader
        motionBlurHolder.zPosition = 20
        
        motionBlurHolder.addChild(circle)
        motionBlurHolder.addChild(sprite)
        return motionBlurHolder
    }
    
    override func didMove(to view: SKView) {
        
        self.selfRenderTextureNode.size = view.frame.size
        
        cropRect = CGRect(x: -400, y: -300, width: 800, height: 600)
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        let sceneTexture = self.scene.view?.texture(from: rootNode, crop: cropRect!)
        
        
    }
}
