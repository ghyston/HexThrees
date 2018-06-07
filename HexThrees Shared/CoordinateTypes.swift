//
//  CoordinateTypes.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 07.06.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

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

// @note: not used atm
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
