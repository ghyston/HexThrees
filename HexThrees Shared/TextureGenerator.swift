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
    static var blueHexTexture: SKTexture?
    
    static func generate(view: SKView) {
        var _ = view.frame //@todo: use this as screen size
        
        let path = createPath(rad: 50)
        
        grayHexTexture = renderShapeToTexture(view, createShape(path, .gray))
        blueHexTexture = renderShapeToTexture(view, createShape(path, .blue))
        
    }
    
    static private func createPath(rad: Double) -> CGPath {
        
        let hexPath = CGMutablePath.init()
        let w = rad, h = rad
        
        hexPath.move(to: CGPoint.init(x: w * 0.5, y: -h * 0.5))
        hexPath.addLine(to: CGPoint.init(x: w * 0.5, y: h * 0.5))
        hexPath.addLine(to: CGPoint.init(x: w * (-0.5), y: h * 0.5))
        hexPath.addLine(to: CGPoint.init(x: w * (-0.5), y: h * (-0.5)))
        hexPath.addLine(to: CGPoint.init(x: w * 0.5, y: h * (-0.5)))
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
