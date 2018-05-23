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
    var bgHexes : [BgCell] = [BgCell]()
    let fieldWidth: Int = 5
    let fieldHeight: Int = 5
    let startOffsetX: Int = -2
    let startOffsetY: Int = -2
    
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
