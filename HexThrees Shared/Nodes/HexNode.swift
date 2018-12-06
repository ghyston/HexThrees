//
//  HexNode.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 04.12.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

protocol HexNode : class {
    
    var hexShape : SKShapeNode { get set }
    
    func addShape(model: GameModel)
    func updateColor(fillColor: SKColor, strokeColor: SKColor)
}

extension HexNode where Self: SKNode {
    
    func addShape(model: GameModel) {
        
        hexShape = model.geometry.createHexCellShape()
        hexShape.fillColor = .white
        hexShape.strokeColor = .white
        hexShape.lineWidth = 0
        
        self.hexShape.zPosition = zPositions.hexCellZ.rawValue
        
        addChild(self.hexShape)
    }
    
    func updateColor(fillColor: SKColor, strokeColor: SKColor) {
        
        hexShape.strokeColor = strokeColor
        hexShape.fillColor = fillColor
    }
}
