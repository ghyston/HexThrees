//
//  FieldBg.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 29.10.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit


class FieldOutline : SKNode {
    
    static let defaultNodeName = "fieldBg"
    
    func recalculateFieldBg(model: GameModel) {
        
        self.removeAllChildren()
        
        for i2 in 0 ..< model.field.width {
            for i1 in 0 ..< model.field.height {                
                let hexShape = model.geometry.createOutlineShape()
                hexShape.fillColor = .darkGray
                hexShape.lineWidth = 0
                hexShape.position = model.geometry.ToScreenCoord(AxialCoord(i2, i1))
                self.addChild(hexShape)
            }
        }
    }
    
    func updateColor(color: SKColor) {
        
        for child in children {
            
            if let shape = child as? SKShapeNode {
                
                shape.fillColor = color
            }
        }
    }
}
