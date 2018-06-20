//
//  GameModel.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 23.05.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

class GameModel {
    
    //@todo: think throw fields vision
    
    // Properties, that are set from c-tor //@todo: allow only get
    
    var mergingStrategy : MergingStrategy// = FibonacciMergingStrategy()
    
    let fieldWidth: Int
    let fieldHeight: Int
    let startOffsetX: Int = -2 //@todo: remo this, use 0 as default, but use screen offset
    let startOffsetY: Int = -2
    let gap = 5.0  //@todo: move somewhere or calculate?
    
    // Calculated properties. @todo: readonly!!!
    
    private let hexRad: Double
    let hexPath: CGPath
    private let cellWidth: Double
    private let cellHeight: Double
    
    // Some common properties
    var bgHexes : [BgCell] = [BgCell]()
    var swipeStatus = SwipeStatus()
    var score : Int = 0
    var newUnblockCellScore : Int = 20 //@todo: make proper calculation regarding this
    
    
    init(scene: GameScene, view: SKView, fieldSize: Int, merging: MergingStrategy) {
        
        self.mergingStrategy = merging
        self.fieldWidth = fieldSize
        self.fieldHeight = fieldSize
        
        self.hexRad = GameModel.calculateHexRad(viewWidth: view.frame.width, hexCount: fieldSize, gap: gap)
        self.hexPath = GameModel.createPath(rad: self.hexRad)
        
        self.cellWidth = hexRad * 1.732
        self.cellHeight = hexRad * 2
    }
    
    class func calculateHexRad(viewWidth: CGFloat, hexCount: Int, gap: Double) -> Double {
        
        let fieldW = Double(viewWidth * 0.9)
        
        return ((fieldW + gap) / Double(hexCount) - gap) / 1.732
    }
    
    class func createPath(rad: Double) -> CGPath {
        
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
    
    func ToScreenCoord(_ a : AxialCoord) -> CGPoint {
        
        //@todo: there are a lot of conversations between float and double. Google difference, use only one mostly
        let w = Float(self.cellWidth + self.gap)
        let h = Float(self.cellHeight + self.gap)
        
        let x = Float(a.c - a.r) * 0.5 * w
        let y = Float(a.c + a.r) * (w * 0.5 + h / (2.0 * 1.732))
        
        return CGPoint(
            x: CGFloat(x),
            y: CGFloat(y))
    }
    
    func ToScreenCoord(_ a : CubeCoord) -> CGPoint {
        return ToScreenCoord(AxialCoord(a))
    }
    
    func setupCleanGameField(scene: GameScene) {
        
        for i2 in startOffsetY ..< startOffsetY + fieldHeight {
            for i1 in startOffsetX ..< startOffsetX + fieldWidth {
                
                AddBgCellCMD(self).run(
                    scene: scene,
                    coord: AxialCoord(i2, i1))
            }
        }
    }
    
}
