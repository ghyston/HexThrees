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
    let startOffsetX: Int = -2 //@todo: remo this, use 0 as default, but use screen offset
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
        
        for i2 in startOffsetY ..< startOffsetY + fieldHeight {
            for i1 in startOffsetX ..< startOffsetX + fieldWidth {
                
                AddBgCellCMD(self).run(scene: scene, coord: AxialCoord(i2, i1))
            }
        }
    }
    
}
