//
//  HexCell.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 12.04.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

enum zPositions: CGFloat {
    
    case bonusZ = 5
    case bgCellZ = 4
    case labelZ = 3
    case hexCellZ = 2
}

class HexCell : SKEffectNode {
    
    //let sprite : SKSpriteNode
    let hexShape : SKShapeNode
    let label : SKLabelNode
    let blur = CIFilter(name: "CIMotionBlur")!
    
    init(model: GameModel, text: String, color: SKColor) {
        
        self.hexShape = model.geometry.createHexCellShape()
        hexShape.fillColor = color
        hexShape.lineWidth = 0
        
        self.label = SKLabelNode(text: text)
        self.label.verticalAlignmentMode = .center
        self.label.fontSize = 22.0
        self.label.fontName = "Futura"
        self.label.position = CGPoint(x: 0, y: 0)
        self.label.fontColor = .white
        self.label.zPosition = zPositions.labelZ.rawValue
        
        super.init()
        
        self.addChild(self.hexShape)
        self.hexShape.addChild(self.label)
        
        self.hexShape.zPosition = zPositions.hexCellZ.rawValue
        
        //@todo: this should be only to gameCell!
        let physicsBody = SKPhysicsBody(polygonFrom: self.hexShape.path!)
        //physicsBody.restitution = 0.0 // @todo: what does thi mean?
        hexShape.physicsBody = physicsBody
        filter = blur
        
        
        //self.frame.width =
    }
    
    func updateText(text: String) {
        self.label.text = text
    }
    
    func updateColor(fillColor: SKColor, strokeColor: SKColor, fontColor: SKColor) {
        
        //this never worked
        //let colorizeAction = SKAction.colorize(with: self.hexShape.fillColor, colorBlendFactor: 0.5, duration: 2.0)
        
        //self.hexShape.run(colorizeAction)
        self.hexShape.strokeColor = strokeColor
        self.hexShape.fillColor = fillColor
        self.label.fontColor = fontColor
    }
    
    func updateMotionBlur()
    {
        if let hexPhysicsBody = hexShape.physicsBody
        {
            let angle = 0.0//atan2(hexPhysicsBody.velocity.dy, hexPhysicsBody.velocity.dx)
            let velocity = 0.0//sqrt(pow(hexPhysicsBody.velocity.dx, 2) + pow(hexPhysicsBody.velocity.dy, 2)) * 0.1
            
            blur.setValue(angle, forKey: kCIInputAngleKey)
            blur.setValue(velocity, forKey: kCIInputRadiusKey)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
