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
    
    let sprite : SKSpriteNode
    let label : SKLabelNode
    
    init(text: String, isGray: Bool) {
        
        //self.sprite = SKSpriteNode.init(imageNamed: isGray ?  "hex_gray" : "hex")
        self.sprite = SKSpriteNode.init(texture: isGray ?
            TextureGenerator.grayHexTexture :
            TextureGenerator.blueHexTexture)
        
        self.label = SKLabelNode(text: text)
        self.label.fontSize = 22.0
        self.label.fontName = "Chalkduster"
        self.label.position = CGPoint(x: 0, y: 0)
        self.label.fontColor = .lightGray
        self.label.zPosition = 2 //@todo: predefine all z-positions!
        
        super.init()
        
        self.addChild(self.sprite)
        self.sprite.addChild(self.label)
        
        self.sprite.zPosition = 1
    }
    
    func updateText(text: String) {
        self.label.text = text
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
