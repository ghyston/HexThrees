//
//  HexFieldSelectorTest.swift
//  HexThreesTests
//
//  Created by Ilja Stepanow on 10.09.19.
//  Copyright © 2019 Ilja Stepanow. All rights reserved.
//

import XCTest
import SpriteKit
@testable import HexThrees

class HexFieldSelectorTest : XCTestCase {
    
    var hexField : HexField!
    var gameModel: GameModel!
    
    override func setUp() {
        
        //Given
        //@todo: we provide field size to geometry as well as w/h to hexField :?
        //@todo: create IGameModel and gameModelMockClass, that can be used in tests
        //let geometry = FieldGeometry(screenWidth: 100, fieldSize: 3)
        let startegy = MerginStrategyFabric.createByName(.Fibonacci)
        //self.hexField = HexField(width: 3, height: 3, geometry: geometry)
        
        self.gameModel = GameModel(
            screenWidth: 100,
            fieldSize: 3,
            strategy: startegy,
            motionBlur: false,
            hapticFeedback: false,
            timerEnabled: false)
        self.hexField = self.gameModel.field
        
        self.hexField[8].block()
        self.hexField[7].block()
        self.hexField[2].addBonus(BonusFabric.createX2Bonus(gameModel: self.gameModel))
    }
    
    func testCountBlockedCells() {
        
        //When
        let freeCellsCount = self.hexField.countBgCells(compare: HexField.freeCell)
        
        //Then
        XCTAssertEqual(freeCellsCount, 7)
    }
    
    func testCountBlockedAndNotBonusedCells() {
        
        //When
        let freeCellsCount = self.hexField.countBgCells(compare: HexField.freeCellWoBonuses)
        
        //Then
        XCTAssertEqual(freeCellsCount, 6)
    }
    
    func testGetCellsWithPriorityExist() {
        
        //When
        let freeCells = self.hexField.getBgCellsWithPriority(
            required: HexField.freeCell,
            priority: HexField.cellWoBonuses)
        
        //Then
        XCTAssertEqual(freeCells.count, 6)
    }
    
    func testGetCellsWithPriorityNotExist() {
        
        //When
        for i in 0...8 {
            self.hexField[i].addBonus(BonusFabric.createX2Bonus(gameModel: self.gameModel))
        }
        
        let freeCells = self.hexField.getBgCellsWithPriority(
            required: HexField.freeCell,
            priority: HexField.cellWoBonuses)
        
        //Then
        XCTAssertEqual(freeCells.count, 7)
    }
    
    func testGetCellsWithSeveralPriorities() {
        
        //When
        self.hexField[5].shape?.fillShader = SKShader()
        let freeCells = self.hexField.getBgCellsWithPriority(
            required: HexField.freeCell,
            priority: HexField.cellWoBonuses, HexField.cellWoShader)
        
        //Then
        XCTAssertEqual(freeCells.count, 5)
    }
    
    
    
}
