//
//  FieldGeometry.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 25.06.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

class FieldGeometry {
    
    private let gap = 5.0
    private var fieldHalfHeight : CGFloat = 0
    
    private let hexRad: Double
    private let hexCellPath: CGPath
    private let outlinePath: CGPath
    private let cellWidth: Double
    private let cellHeight: Double
    
    init(screenWidth: CGFloat, fieldSize: Int) {
        
        self.hexRad = FieldGeometry.calculateHexRad(
            viewWidth: screenWidth,
            hexCount: fieldSize,
            gap: gap)
        
        self.hexCellPath = FieldGeometry.createPath(rad: self.hexRad)
        self.outlinePath = FieldGeometry.createPath(rad: self.hexRad + self.gap)
        
        self.cellWidth = hexRad * 1.732
        self.cellHeight = hexRad * 2
        
        let furthestCellCoord = ToScreenCoord(AxialCoord(fieldSize - 1, fieldSize - 1))
        self.fieldHalfHeight = furthestCellCoord.y / 2.0
    }
    
    func createHexCellShape() -> SKShapeNode {
        
        return createShape (path: self.hexCellPath)
    }
    
    func createOutlineShape() -> SKShapeNode {
        
        return createShape (path: self.outlinePath)
    }
    
    private func createShape(path: CGPath) -> SKShapeNode {
        
        let hexShape = SKShapeNode()
        hexShape.path = path
        return hexShape
    }
    
    class func calculateHexRad(viewWidth: CGFloat, hexCount: Int, gap: Double) -> Double {
        
        let fieldW = Double(viewWidth * 0.9)
        
        return ((fieldW + gap) / Double(hexCount) - gap) / 1.732
    }
    
    class func createPath(rad: Double) -> CGPath {
        
        let hexPath = CGMutablePath.init()
        
        let xCoef = 1.732 * 0.5
        let yCoef = 0.5
        let curveCoef = 0.85
        
        let p0 = CGPoint.init(x: 0.0, y: rad)
        let p1 = CGPoint.init(x: rad * xCoef, y: rad * yCoef)
        let p2 = CGPoint.init(x: rad * xCoef, y: -rad * yCoef)
        let p3 = CGPoint.init(x: 0.0, y: -rad)
        let p4 = CGPoint.init(x: -rad * xCoef, y: -rad * yCoef)
        let p5 = CGPoint.init(x: -rad * xCoef, y: rad * yCoef)
        
        let p0dy = CGFloat( (rad - rad * yCoef) * (1 - curveCoef))
        let p1dy = CGFloat( rad * yCoef * (1 - curveCoef))
        let dx = CGFloat( rad * xCoef * (1 - curveCoef))
        
        
        let p0l = CGPoint(x: p0.x - dx, y: p0.y - p0dy)
        let p0r = CGPoint(x: p0.x + dx, y: p0.y - p0dy)
        
        let p1l = CGPoint(x: p1.x - dx, y: p1.y + p1dy)
        let p1r = CGPoint(x: p1.x, y: p1.y - p1dy)
        
        let p2l = CGPoint(x: p2.x, y: p2.y + p1dy)
        let p2r = CGPoint(x: p2.x - dx, y: p2.y - p1dy)
        
        let p3l = CGPoint(x: p3.x + dx, y: p3.y + p0dy)
        let p3r = CGPoint(x: p3.x - dx, y: p3.y + p0dy)
        
        let p4l = CGPoint(x: p4.x + dx, y: p4.y - p1dy)
        let p4r = CGPoint(x: p4.x, y: p4.y + p0dy)
        
        let p5l = CGPoint(x: p5.x, y: p5.y - p1dy)
        let p5r = CGPoint(x: p5.x + dx, y: p5.y + p0dy)
        
        hexPath.move(to: p0l)
        hexPath.addQuadCurve(to: p0r, control: p0)
        hexPath.addLine(to: p1l)
        hexPath.addQuadCurve(to: p1r, control: p1)
        hexPath.addLine(to: p2l)
        hexPath.addQuadCurve(to: p2r, control: p2)
        hexPath.addLine(to: p3l)
        
        hexPath.addQuadCurve(to: p3r, control: p3)
        hexPath.addLine(to: p4l)
        
        hexPath.addQuadCurve(to: p4r, control: p4)
        hexPath.addLine(to: p5l)
        
        hexPath.addQuadCurve(to: p5r, control: p5)
        hexPath.addLine(to: p0l)
        
        return hexPath
    }
    
    class func createPathWOCurving(rad: Double) -> CGPath {
        
        let hexPath = CGMutablePath.init()
        
        let xCoef = 1.732 * 0.5
        let yCoef = 0.5
        
        let p0 = CGPoint.init(x: 0.0, y: rad)
        let p1 = CGPoint.init(x: rad * xCoef, y: rad * yCoef)
        let p2 = CGPoint.init(x: rad * xCoef, y: -rad * yCoef)
        let p3 = CGPoint.init(x: 0.0, y: -rad)
        let p4 = CGPoint.init(x: -rad * xCoef, y: -rad * yCoef)
        let p5 = CGPoint.init(x: -rad * xCoef, y: rad * yCoef)
        
        hexPath.move(to: p0)
        hexPath.addLine(to: p1)
        hexPath.addLine(to: p2)
        hexPath.addLine(to: p3)
        hexPath.addLine(to: p4)
        hexPath.addLine(to: p5)
        hexPath.addLine(to: p0)
        
        return hexPath
    }
    
    func ToScreenCoord(_ a : AxialCoord) -> CGPoint {
        
        //@todo: there are a lot of conversations between float and double. Google difference, use only one mostly
        let w = Float(self.cellWidth + self.gap)
        let h = Float(self.cellHeight + self.gap * 1.732)
        
        let x = Float(a.c - a.r) * 0.5 * w
        let y = Float(a.c + a.r) * (w * 0.5 + h / (2.0 * 1.732))
        
        
        return CGPoint(
            x: CGFloat(x),
            y: CGFloat(y) - self.fieldHalfHeight)
    }
    
    func ToScreenCoord(_ a : CubeCoord) -> CGPoint {
        
        return ToScreenCoord(AxialCoord(a))
    }
}
