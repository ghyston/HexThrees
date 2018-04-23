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
    
    init(text: String) {
        
        self.sprite = SKSpriteNode.init(imageNamed: "hex_gray")
        self.label = SKLabelNode(text: text)
        self.label.fontSize = 22.0
        self.label.fontName = "Chalkduster"
        self.label.position = CGPoint(x: 0, y: 0)
        self.label.fontColor = .lightGray
        
        
        super.init()
        
        self.addChild(self.sprite)
        self.sprite.addChild(self.label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
