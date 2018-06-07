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

extension SKColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

class TextureGenerator {
    
    static var grayHexTexture: SKTexture?
    
    //$color1: rgba(19, 21, 21, 1);
    //$color2: rgba(43, 44, 40, 1);
    //$color3: rgba(51, 153, 137, 1);
    //$color4: rgba(125, 226, 209, 1);
    //$color5: rgba(255, 250, 251, 1);
    
    
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
