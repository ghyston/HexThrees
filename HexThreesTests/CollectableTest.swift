//
//  CollectableTest.swift
//  HexThreesTests
//
//  Created by Ilja Stepanow on 10.10.19.
//  Copyright © 2019 Ilja Stepanow. All rights reserved.
//

import Foundation
import XCTest
@testable import HexThrees


class CollectableTests : XCTestCase {
    
    /*var btn1 : CollectableBtn!
    var btn2 : CollectableBtn!
    var model : GameModel!
    
    override func setUp() {
        self.model = GameModel(
            screenWidth: 100,
            fieldSize: 3,
            strategy: MerginStrategyFabric.createByName(.Fibonacci),
            motionBlur: false,
            hapticFeedback: false,
            timerEnabled: false)
        
        ContainerConfig.instance.register(self.model)
        
        self.btn1 = CollectableBtn(type: BonusType.COLLECTABLE_TYPE_1)
        self.btn2 = CollectableBtn(type: BonusType.COLLECTABLE_TYPE_2)
    }
    
    func testClickDoNothing() {
        
        // When
        btn1.onClick()
        btn2.onClick()
        
        // Then
        let val1 = self.model.collectableBonuses[BonusType.COLLECTABLE_TYPE_1]?.currentValue
       XCTAssertEqual(val1, 0)
        let val2 = self.model.collectableBonuses[BonusType.COLLECTABLE_TYPE_2]?.currentValue
        XCTAssertEqual(val2, 0)
    }
    
    func testOneInc() {
        
        // When
        IncCollectableBonusCMD(self.model, type: BonusType.COLLECTABLE_TYPE_1).run()
        
        // Then
        let val1 = self.model.collectableBonuses[BonusType.COLLECTABLE_TYPE_1]?.currentValue
        XCTAssertEqual(val1, 1)
    }
    
    func testSeveralIncs() {
        
        // When
        IncCollectableBonusCMD(self.model, type: BonusType.COLLECTABLE_TYPE_1).run()
        IncCollectableBonusCMD(self.model, type: BonusType.COLLECTABLE_TYPE_1).run()
        IncCollectableBonusCMD(self.model, type: BonusType.COLLECTABLE_TYPE_2).run()
        
        // Then
        let val1 = self.model.collectableBonuses[BonusType.COLLECTABLE_TYPE_1]?.currentValue
        XCTAssertEqual(val1, 2)
        
        let val2 = self.model.collectableBonuses[BonusType.COLLECTABLE_TYPE_2]?.currentValue
        XCTAssertEqual(val2, 1)
    }
    
    func testCollectableCompletelyCollected() {
        
        // When
        for _ in 0...10 {
            IncCollectableBonusCMD(self.model, type: BonusType.COLLECTABLE_TYPE_1).run()
        }
        IncCollectableBonusCMD(self.model, type: BonusType.COLLECTABLE_TYPE_2).run()
        
        // Then
        let val1 = self.model.collectableBonuses[BonusType.COLLECTABLE_TYPE_1]?.currentValue
        let maxVal1 = self.model.collectableBonuses[BonusType.COLLECTABLE_TYPE_1]?.maxValue
        XCTAssertEqual(val1, maxVal1)
        
        let val2 = self.model.collectableBonuses[BonusType.COLLECTABLE_TYPE_2]?.currentValue
        XCTAssertEqual(val2, 1)
    }
    
    func testCorrectCollectableClicked() {
        
        // When
        for _ in 0...10 {
            IncCollectableBonusCMD(self.model, type: BonusType.COLLECTABLE_TYPE_1).run()
        }
        btn1.onClick()
        //@todo: use cmdFactory to check, that proper command was called
        
        //@todo: check, that timerStopCMD was called
        let node = self.model.field[0]
        TouchSelectableCellCMD(self.model).setup(node: node).run()
        //@todo: check, that timerStartCMD was called
        
        // Then
        let val1 = self.model.collectableBonuses[BonusType.COLLECTABLE_TYPE_1]?.currentValue
        XCTAssertEqual(val1, 0)
    }
    */
}
