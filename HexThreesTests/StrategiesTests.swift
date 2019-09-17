//
//  StrategiesTests.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 27.08.19.
//  Copyright © 2019 Ilja Stepanow. All rights reserved.
//

import XCTest
@testable import HexThrees

class StrategiesTests: XCTestCase {

    func testFibonacci() {
        
        // Given
        let strategy = MerginStrategyFabric.createByName(.Fibonacci)
        
        // When
        strategy.prefilValues(maxIndex: 5)
        
        //Then
        XCTAssertEqual(strategy[0], 1)
        XCTAssertEqual(strategy[1], 2)
        XCTAssertEqual(strategy[2], 3)
        XCTAssertEqual(strategy[3], 5)
        XCTAssertEqual(strategy[4], 8)
        XCTAssertEqual(strategy[5], 13)
        
        XCTAssertEqual(strategy.isSiblings(0, 0), 1)
        XCTAssertEqual(strategy.isSiblings(1, 0), 2)
        XCTAssertEqual(strategy.isSiblings(2, 1), 3)
        XCTAssertNil(strategy.isSiblings(0, 1))
        XCTAssertNil(strategy.isSiblings(0, 2))
        XCTAssertNil(strategy.isSiblings(1, 2))
        
        //XCTAssertThrowsError(strategy[15])
        //@todo: how to test that strategy[5] throw assert?
    }
    
    func testPowerOfTwo() {
        
        // Given
        let strategy = MerginStrategyFabric.createByName(.PowerOfTwo)
        
        // When
        strategy.prefilValues(maxIndex: 7)
        
        //Then
        XCTAssertEqual(strategy[0], 2)
        XCTAssertEqual(strategy[1], 4)
        XCTAssertEqual(strategy[2], 8)
        XCTAssertEqual(strategy[3], 16)
        XCTAssertEqual(strategy[4], 32)
        XCTAssertEqual(strategy[5], 64)
        XCTAssertEqual(strategy[6], 128)
        
        XCTAssertEqual(strategy.isSiblings(0, 0), 1)
        XCTAssertEqual(strategy.isSiblings(1, 1), 2)
        XCTAssertEqual(strategy.isSiblings(2, 2), 3)
        XCTAssertEqual(strategy.isSiblings(8, 8), 9)
        XCTAssertNil(strategy.isSiblings(0, 1))
        XCTAssertNil(strategy.isSiblings(1, 0))
        XCTAssertNil(strategy.isSiblings(0, 2))
        XCTAssertNil(strategy.isSiblings(1, 2))
        XCTAssertNil(strategy.isSiblings(2, 1))
        
        //XCTAssertThrowsError(strategy[15])
        //@todo: how to test that strategy[5] throw assert?
    }
    
    func testHybrid() {
        // Given
        let strategy = MerginStrategyFabric.createByName(.Hybrid)
        
        // When
        strategy.prefilValues(maxIndex: 10)
        
        //Then
        XCTAssertEqual(strategy[0], 1)
        XCTAssertEqual(strategy[1], 2)
        XCTAssertEqual(strategy[2], 3)
        XCTAssertEqual(strategy[3], 5)
        XCTAssertEqual(strategy[4], 8)
        XCTAssertEqual(strategy[5], 16)
        XCTAssertEqual(strategy[6], 32)
        XCTAssertEqual(strategy[7], 64)
        XCTAssertEqual(strategy[8], 128)
        XCTAssertEqual(strategy[9], 256)
        
        XCTAssertEqual(strategy.isSiblings(0, 0), 1)
        XCTAssertEqual(strategy.isSiblings(1, 0), 2)
        XCTAssertEqual(strategy.isSiblings(2, 1), 3)
        XCTAssertNil(strategy.isSiblings(0, 1))
        XCTAssertNil(strategy.isSiblings(0, 2))
        XCTAssertNil(strategy.isSiblings(1, 2))
        
        XCTAssertNil(strategy.isSiblings(3, 3))
        XCTAssertNil(strategy.isSiblings(3, 4))
        XCTAssertNil(strategy.isSiblings(4, 3))
        XCTAssertEqual(strategy.isSiblings(4, 4), 5)
        
        XCTAssertEqual(strategy.isSiblings(5, 5), 6)
        XCTAssertEqual(strategy.isSiblings(8, 8), 9)
        XCTAssertNil(strategy.isSiblings(5, 6))
        XCTAssertNil(strategy.isSiblings(6, 5))
    }
    
    func testTutorial() {
        // Given
        let strategy = MerginStrategyFabric.createByName(.Tutorial)
        
        // When
        strategy.prefilValues(maxIndex: 5)
        
        //Then
        XCTAssertEqual(strategy[0], 0)
        XCTAssertEqual(strategy[1], 1)
        XCTAssertEqual(strategy[2], 2)
        
        XCTAssertNil(strategy.isSiblings(0, 0))
        XCTAssertNil(strategy.isSiblings(0, 1))
        XCTAssertNil(strategy.isSiblings(1, 0))
        XCTAssertNil(strategy.isSiblings(6, 5))
    }
}
