//
//  HexCalculator.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 11.04.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation
import CoreGraphics

class AxialCoord {
    var r : Int = 0 //row
    var c : Int = 0 //column
    
    init(_ r: Int, _ c: Int) {
        self.r = r
        self.c = c
    }
    
    init(_ cube: CubeCoord) {
        self.c = cube.x
        self.r = cube.z
    }
    
    func ToCube() -> CubeCoord {
        return CubeCoord(self)
    }
}

class CubeCoord {
    var x : Int = 0
    var y : Int = 0
    var z : Int = 0
    
    init(x: Int, y: Int, z: Int) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    init(_ axial: AxialCoord) {
        self.x = axial.c
        self.y = -axial.c - axial.r
        self.z = axial.r
    }
    
    func ToAxial() -> AxialCoord {
        return AxialCoord(self)
    }
}

class HexCalculator {
    
    let width : Int
    let height : Int
    let gap: Float
    let cellWidth: Float
    let cellHeight: Float
    
    init(width : Int, height : Int, gap: Float, cellSize: CGSize) {
        
        self.width = width
        self.height = height
        self.gap = gap
        self.cellWidth = Float(cellSize.width)
        self.cellHeight = Float(cellSize.height)
    }
    
    func ToScreenCoord(_ a : AxialCoord) -> CGPoint {
        
        let w = self.cellWidth + self.gap
        let h = self.cellHeight + self.gap
        
        //@todo: check this, add gap
        let x = Float(a.c - a.r) * 0.5 * w
        let y = Float(a.c + a.r) * (w * 0.5 + h / (2.0 * 1.732))
        
        return CGPoint(
            x: CGFloat(x),
            y: CGFloat(y))
    }
    
    func ToScreenCoord(_ a : CubeCoord) -> CGPoint {
        return ToScreenCoord(AxialCoord(a))
    }
}



