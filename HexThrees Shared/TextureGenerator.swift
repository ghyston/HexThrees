//
//  TextureGenerator.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 04.06.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit
import GameKit

class TextureGenerator {
    
    static var grayHexTexture: SKTexture?
    
    static let colors: Dictionary =
        [1: SKColor(rgb: 0xfffafb),
         2: SKColor(rgb: 0x7de2d1),
         3: SKColor(rgb: 0x339989),
         5: SKColor(rgb: 0x2b2c28),
         8: SKColor(rgb: 0x131515),
         
         13: SKColor(rgb: 0xDCC7BE),
         21: SKColor(rgb: 0xCBB9A8),
         34: SKColor(rgb: 0x145C9E),
         55: SKColor(rgb: 0x0B4F6C),
         89: SKColor(rgb: 0x405138),
         144: SKColor(rgb: 0x9CEAEF),
         233: SKColor(rgb: 0x07BEB8)]
    
    static var textures = Dictionary<Int, SKTexture>()
    
    static func getTexture(value: Int) -> SKTexture {
        
        return textures[value]!
    }
    
    static func generate(view: SKView, hexCount: Int) {
        var _ = view.frame //@todo: use this as screen size
        
        //@todo: here fieldSize is hex counts by x, supposing, that fieldWidth == fieldHeight
        let fieldW = Double(view.frame.width * 0.9)
        let gap : Double = 5.0 //@todo: move ot config? It's gap between hexes in pixels
        
        let rad = ((fieldW + gap) / Double(hexCount) - gap) / 1.732
        
        let hexPath = createPath(rad: rad)
        
        grayHexTexture = renderShapeToTexture(view, createShape(hexPath, .gray))
        
        for color in colors {
            
            textures[color.key] = renderShapeToTexture(view, createShape(hexPath, color.value))
        }
        
    }
    
    static private func createPath(rad: Double) -> CGPath {
        
        let hexPath = CGMutablePath.init()
        
        let xCoef = 1.732 * 0.5
        let yCoef = 0.5
        
        hexPath.move(to: CGPoint.init(x: 0.0, y: rad))
        hexPath.addLine(to: CGPoint.init(x: rad * xCoef, y: rad * yCoef))
        hexPath.addLine(to: CGPoint.init(x: rad * xCoef, y: -rad * yCoef))
        hexPath.addLine(to: CGPoint.init(x: 0.0, y: -rad))
        hexPath.addLine(to: CGPoint.init(x: -rad * xCoef, y: -rad * yCoef))
        hexPath.addLine(to: CGPoint.init(x: -rad * xCoef, y: rad * yCoef))
        hexPath.addLine(to: CGPoint.init(x: 0.0, y: rad))
        return hexPath
    }
    
    static private func createShape(_ path: CGPath, _ fillColor: SKColor) -> SKShapeNode {
        
        let hexShape = SKShapeNode()
        hexShape.path = path
        hexShape.strokeColor = SKColor.white
        hexShape.lineWidth = 1
        hexShape.fillColor = fillColor
        return hexShape
    }
    
    static private func renderShapeToTexture(_ view: SKView, _ shape: SKShapeNode) -> SKTexture {
        
        return view.texture(from: shape)!
    }
    
}
