//
//  LabeledNode.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 04.12.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

protocol LabeledNode : class {
    
    var label : SKLabelNode { get set }
    
    func addLabel(text: String)
    func updateText(text: String)
    func updateColor(fontColor: SKColor)
}

extension LabeledNode where Self: SKNode {
    
    func addLabel(text: String) {
        
        label = SKLabelNode()
        label.text = text
        label.verticalAlignmentMode = .center
        label.fontSize = 22.0
        label.fontName = "Futura"
        label.position = CGPoint(x: 0, y: 0)
        label.zPosition = zPositions.labelZ.rawValue
        
        addChild(label)
    }
    
    func updateText(text: String) {
        
        label.text = text
    }
    
    func updateColor(fontColor: SKColor) {
        
        label.fontColor = fontColor
    }
}

