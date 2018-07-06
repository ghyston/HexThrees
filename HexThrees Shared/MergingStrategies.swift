//
//  Fibonacci.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 23.04.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

enum MergingStrategyName: Int {
    
    case Fibonacci = 0
    case PowerOfTwo = 1
}

class MerginStrategyFabric {
    
    static func createByName(_ name: MergingStrategyName) -> MergingStrategy {
        
        switch name {
        case .Fibonacci:
            return FibonacciMergingStrategy()
        case .PowerOfTwo:
            return PowerOfTwoMergingStrategy()
        }
    }
}

protocol MergingStrategy {
    
    func prefilValues(maxIndex: Int)
    func value(index: Int) -> Int
    func isSiblings(_ one: Int, _ two: Int) -> Int?
}

class FibonacciMergingStrategy : MergingStrategy {
    
    var values = [Int]()
    
    func prefilValues(maxIndex: Int) {
        
        values.removeAll()
        values.append(1)
        values.append(2)
        
        for i in 2...maxIndex {
            
            let val = values[i-1] + values[i-2]
            values.append(val)
        }
    }
    
    func value(index: Int) -> Int {
        
        //@todo: throw if index is more that values size
        return values[index]
    }
    
    func isSiblings(_ one: Int, _ two: Int) -> Int? {
        
        return two == one - 1 || (one == two && one == 0) ? one + 1 : nil
    }
}

class PowerOfTwoMergingStrategy : MergingStrategy {
    
    var values : [Int] = [Int]()
    
    func prefilValues(maxIndex: Int) {
        
        values.removeAll()
        for i in 1...maxIndex {
            
            let val = Int(truncating: NSDecimalNumber(decimal: pow(2.0, i)))
            values.append(val)
        }
    }
    
    func value(index: Int) -> Int {
        
        //@todo: throw if index is more that values size
        return values[index]
    }
    
    func isSiblings(_ one: Int, _ two: Int) -> Int? {
        
        return one == two ? two + 1 : nil
    }
}

