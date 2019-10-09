//
//  CellsGrid.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 26.08.19.
//  Copyright © 2019 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

typealias CellComparator = (_ cell: BgCell) -> Bool //@todo: use it!

protocol ICellsStatisticCalculator {
    
    func next(cell: BgCell)
    func clean()
}

class HexField {
    
    private var bgHexes = [BgCell]()
    let width: Int
    let height: Int
    
    init(width: Int, height: Int, geometry: FieldGeometry) {
        self.width = width
        self.height = height
        
        for i2 in 0 ..< width {
            for i1 in 0 ..< height {
                let coord = AxialCoord(i2, i1)
                let hexCell = BgCell(
                    hexShape: geometry.createHexCellShape(),
                    blocked: false,
                    coord: coord)
                hexCell.position = geometry.ToScreenCoord(coord)
                bgHexes.append(hexCell)
            }
        }
    }
    
    func clean() {
        for i in 0 ..< bgHexes.count {
            self[i].removeAllActions()
            self[i].removeFromParent()
        }
        bgHexes.removeAll()
    }
    
    //@todo: how to create lambda with prdefined first argument?
    func addToScene(scene: SKScene) {
        for i in 0 ..< bgHexes.count {
            scene.addChild(self[i])
        }
    }
    
    subscript (index: Int) -> BgCell {
        return bgHexes[index]
    }
    
    subscript (x: Int, y: Int) -> BgCell {
        assert(x >= 0 && x < width, "cell coordinate \(x) out of range")
        assert(y >= 0 && y < height, "cell coordinate \(y) out of range")
        let index = y * width + x
        return bgHexes[index]
    }
    
    func getCell(_ x: Int, _ y: Int) -> BgCell {
        
        assert(x >= 0 && x < width, "cell coordinate \(x) out of range")
        assert(y >= 0 && y < height, "cell coordinate \(y) out of range")
        let index = y * width + x
        return bgHexes[index]
    }
    
    func getBgCells(compare: (_: BgCell) -> Bool) -> [BgCell] {
        return self.bgHexes.filter(compare)
    }
    
    func hasBgCells(compare: (_: BgCell) -> Bool) -> Bool {
        return self.bgHexes.first(where: compare) != nil
    }
    
    func getBgCellsWithPriority(
        required: (_: BgCell) -> Bool,
        priority: (_: BgCell) -> Bool...) -> [BgCell] {
        let cells = getBgCells(compare: required)
        var preferedCells = cells
        for preferFilter in priority {
            preferedCells = preferedCells.filter(preferFilter)
        }
        return preferedCells.count > 0 ? preferedCells : cells
    }
    
    func countBgCells(compare: (_: BgCell) -> Bool) -> Int {
        return self.bgHexes.filter(compare).count
    }
    
    func executeForAll(lambda: (_:BgCell) -> Void) {
        for i in 0 ..< bgHexes.count {
            lambda(self[i])
        }
    }
    
    class func freeCell(cell: BgCell) -> Bool {
        return cell.gameCell == nil && !cell.isBlocked
    }
    
    class func freeCellWoBonuses(cell: BgCell) -> Bool {
        return cell.gameCell == nil && !cell.isBlocked &&
            cell.bonus == nil
    }
    
    class func cellWoBonuses(cell: BgCell) -> Bool {
        return cell.bonus == nil
    }
    
    class func cellWoShader(cell: BgCell) -> Bool {
        return cell.shape?.fillShader == nil
    }
    
//    func executeForAll(lambda: (_:BgCell, _: Int, _: Int) -> Void) {
//        for y in 0 ..< height {
//            for x in 0 ..< width {
//                lambda(self[x, y], x, y)
//            }
//        }
//    }
//
//    func executeForAll(lambda: (_:BgCell, _: Int) -> Void) {
//        for i in 0 ..< height * width {
//            lambda(self[i], i)
//        }
//    }
    
    func calculateForSiblings(coord: AxialCoord, calc: inout ICellsStatisticCalculator) {

        calc.clean()

        let xMin = max(coord.c - 1, 0)
        let xMax = min(coord.c + 1, width - 1)
        let yMin = max(coord.r - 1, 0)
        let yMax = min(coord.r + 1, height - 1)


        for x in xMin...xMax  {
            for y in yMin ... yMax {

                // here skipping self cell and corner cells (because of hex geometry)
                if (x == coord.c && y == coord.r) || x == y {
                    continue
                }

                calc.next(cell: self[x, y])
            }
        }
    }
}
