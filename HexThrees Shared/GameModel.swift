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
    
    var hexCalculator : HexCalculator?
    var mergingStrategy : MergingStrategy = FibonacciMergingStrategy()
    
    let fieldWidth: Int = 4
    let fieldHeight: Int = 4
    let startOffsetX: Int = -2
    let startOffsetY: Int = -2
    
    var bgHexes : [BgCell] = [BgCell]()
    var swipeStatus = SwipeStatus()
    
    var lastDuration = 0 //@todo: use this to implement "current move finished"
    
    func setupCleanGameField(cellSize: CGSize, scene: GameScene) {
        
        hexCalculator = HexCalculator(
            width : fieldWidth,
            height : fieldHeight,
            gap: 5.0,
            cellSize: cellSize)
        
        var i = 0
        for i2 in startOffsetY ..< startOffsetY + fieldHeight {
            for i1 in startOffsetX ..< startOffsetX + fieldWidth {
                
                let hexCell = BgCell(
                    coord: AxialCoord(i2, i1),
                    hexCalc : hexCalculator!)
                scene.addChild(hexCell)
                self.bgHexes.append(hexCell)
                i += 1
            }
        }
    }
    
}
