//
//  HexCell.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 12.04.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

class HexCell : SKNode {
    
    //let sprite : SKSpriteNode
    let hexShape : SKShapeNode
    let label : SKLabelNode
    
    init(model: GameModel, text: String, color: SKColor) {
        
        self.hexShape = SKShapeNode()
        hexShape.path = model.hexPath
        hexShape.strokeColor = SKColor.white
        hexShape.lineWidth = 1
        hexShape.fillColor = color
        
        self.label = SKLabelNode(text: text)
        self.label.fontSize = 22.0
        self.label.fontName = "Chalkduster"
        self.label.position = CGPoint(x: 0, y: 0)
        self.label.fontColor = .white
        self.label.zPosition = 2 //@todo: predefine all z-positions!
        
        super.init()
        
        self.addChild(self.hexShape)
        self.hexShape.addChild(self.label)
        
        self.hexShape.zPosition = 1
    }
    
    func updateText(text: String) {
        self.label.text = text
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
