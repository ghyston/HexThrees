//
//  GameModel.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 23.05.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

protocol ICellsStatisticCalculator {
    
    func next(cell: BgCell)
    func clean()
}

class GameModel {
    
    var fieldWidth: Int
    var fieldHeight: Int
    var strategy: MergingStrategy
    var geometry: FieldGeometry
    var hapticManager: IHapticManager
    var motionBlurEnabled: Bool
    
    var stressTimerEnabled: Bool
    var stressTimer : Timer? //when this timer is fired, new cell appeared on field
    
    // Some common properties
    var bgHexes = [BgCell]()
    var swipeStatus = SwipeStatus()
    var score : Int = 0
    var scoreBuffs = [ScoreBuff]()
    var scoreMultiplier : Int = 1
    var turnsWithoutBonus : Int = 0
    
    func getCell(_ x: Int, _ y: Int) -> BgCell {
        
        assert(x >= 0 && x < fieldWidth, "cell coordinate \(x) out of range")
        assert(y >= 0 && y < fieldHeight, "cell coordinate \(y) out of range")
        let index = y * fieldWidth + x
        return bgHexes[index]
    }
    
    func getBgCells(compare: (_: BgCell) -> Bool) -> [BgCell] {
        
        return self.bgHexes.filter(compare)
    }
    
    func hasBgCells(compare: (_: BgCell) -> Bool) -> Bool {
        
        return self.bgHexes.first(where: compare) != nil
    }
    
    func countBgCells(compare: (_: BgCell) -> Bool) -> Int {
        
        return self.bgHexes.filter(compare).count
    }
    
    func calculateForSiblings(coord: AxialCoord, calc: inout ICellsStatisticCalculator) {
        
        calc.clean()
        
        let xMin = max(coord.c - 1, 0)
        let xMax = min(coord.c + 1, fieldWidth - 1)
        let yMin = max(coord.r - 1, 0)
        let yMax = min(coord.r + 1, fieldHeight - 1)
        
        
        for x in xMin...xMax  {
            for y in yMin ... yMax {
                
                // here skipping self cell and corner cells (because of hex geometry)
                if (x == coord.c && y == coord.r) || x == y {
                    continue
                }
                
                calc.next(cell: getCell(x, y))
            }
        }
    }
    
    func recalculateScoreBaff(){
        
        self.scoreMultiplier = 1
        for buff in scoreBuffs {
            self.scoreMultiplier *= buff.factor
        }
    }
    
    init(screenWidth: CGFloat, fieldSize: Int, strategy: MergingStrategy, motionBlur: Bool, hapticFeedback: Bool, stressTimer: Bool) {
        
        self.geometry = FieldGeometry(
            screenWidth: screenWidth,
            fieldSize: fieldSize)
        self.strategy = strategy
        self.fieldWidth = fieldSize
        self.fieldHeight = fieldSize
        self.motionBlurEnabled = motionBlur
        self.hapticManager = HapticManager(enabled: hapticFeedback)
        self.stressTimerEnabled = stressTimer
    }
    
    func reset(screenWidth: CGFloat, fieldSize: Int, strategy: MergingStrategy) {
        
        self.geometry = FieldGeometry(
            screenWidth: screenWidth,
            fieldSize: fieldSize)
        self.strategy = strategy
        self.fieldWidth = fieldSize
        self.fieldHeight = fieldSize
    }
}
