//
//  GameModel.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 23.05.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

enum GameState {
    
    case InPlay
    case Finished
}

class GameModel {
    
    var fieldWidth: Int
    var fieldHeight: Int
    var strategy: MergingStrategy
    var geometry: FieldGeometry
    var status: GameState = .InPlay // @todo: read about gameKit state machines
    
    // Some common properties
    var bgHexes = [BgCell]()
    var swipeStatus = SwipeStatus()
    var score : Int = 0
    var scoreBuffs = [ScoreBuff]()
    var scoreMultiplier : Int = 1
    var newUnblockCellScore : Int = 20 //@todo: make proper calculation related to field size and strategy
    var turnsWithoutBonus : Int = 0
    
    func getBgCells(compare: (_: BgCell) -> Bool) -> [BgCell] {
        
        return self.bgHexes.filter(compare)
    }
    
    func hasBgCells(compare: (_: BgCell) -> Bool) -> Bool {
        
        return self.bgHexes.first(where: compare) != nil
    }
    
    func countBgCells(compare: (_: BgCell) -> Bool) -> Int {
        
        return self.bgHexes.filter(compare).count
    }
    
    init(screenWidth: CGFloat, fieldSize: Int, strategy: MergingStrategy) {
        
        self.geometry = FieldGeometry(
            screenWidth: screenWidth,
            fieldSize: fieldSize)
        self.strategy = strategy
        self.fieldWidth = fieldSize
        self.fieldHeight = fieldSize
    }
    
    func reset(screenWidth: CGFloat, fieldSize: Int, strategy: MergingStrategy) {
        
        self.geometry = FieldGeometry(
            screenWidth: screenWidth,
            fieldSize: fieldSize)
        self.strategy = strategy
        self.fieldWidth = fieldSize
        self.fieldHeight = fieldSize
    }
    
    func finishGame() {
        
        self.status = .Finished
    }
}
