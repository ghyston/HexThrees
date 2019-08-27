//
//  Fibonacci.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 23.04.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class MerginStrategyFabric {
    
    static func createByName(_ name: MergingStrategyName) -> MergingStrategy {
        
        switch name {
        case .Fibonacci:
            return FibonacciMergingStrategy()
        case .PowerOfTwo:
            return PowerOfTwoMergingStrategy()
        case .Hybrid:
            return HybridMergingStrategy()
        case .Tutorial:
            return TutorialMergingStrategy()
        }
    }
}

protocol MergingStrategy {
    
    var name : MergingStrategyName { get }
    func prefilValues(maxIndex: Int)
    func isSiblings(_ one: Int, _ two: Int) -> Int?
    subscript(index: Int) -> Int { get }
}

class FibonacciMergingStrategy : MergingStrategy {
    
    var values = [Int]()
    var name : MergingStrategyName = .Fibonacci
    
    subscript(index: Int) -> Int {
        assert(index < values.endIndex, "FibonacciMergingStrategy: index \(index) out of range")
        return values[index]
    }
    
    func prefilValues(maxIndex: Int) {
        
        values.removeAll()
        values.append(1)
        values.append(2)
        
        for i in 2...maxIndex {
            
            let val = values[i-1] + values[i-2]
            values.append(val)
        }
    }
    
    func isSiblings(_ one: Int, _ two: Int) -> Int? {
        
        return two == one - 1 || (one == two && one == 0) ? one + 1 : nil
    }
}

class PowerOfTwoMergingStrategy : MergingStrategy {
    
    var values = [Int]()
    var name : MergingStrategyName = .PowerOfTwo
    
    subscript(index: Int) -> Int {
        assert(index < values.endIndex, "PowerOfTwoMergingStrategy: index \(index) out of range")
        return values[index]
    }
    
    func prefilValues(maxIndex: Int) {
        
        values.removeAll()
        for i in 1...maxIndex {
            
            let val = Int(truncating: NSDecimalNumber(decimal: pow(2.0, i)))
            values.append(val)
        }
    }
    
    func isSiblings(_ one: Int, _ two: Int) -> Int? {
        
        return one == two ? two + 1 : nil
    }
}

class HybridMergingStrategy : MergingStrategy {
    
    let fib : MergingStrategy = MerginStrategyFabric.createByName(.Fibonacci)
    let pot : MergingStrategy = MerginStrategyFabric.createByName(.PowerOfTwo)
    let limitValue = 3
    var name : MergingStrategyName = .Hybrid
    
    /*
    0 1 2
    1 2 4
    2 3 8
    3 5 16
    4 8 32
     */
    
    subscript(index: Int) -> Int {
        let strategy = takeStrategy(index)
        // 8 has index 5 in Fibo, but index 3 in 2048
        let takeIndex = strategy.name == .Fibonacci ? index : index - (limitValue - 1)
        return strategy[takeIndex]
    }
    
    func prefilValues(maxIndex: Int) {
        
        fib.prefilValues(maxIndex: maxIndex)
        pot.prefilValues(maxIndex: maxIndex)
    }
    
    func isSiblings(_ one: Int, _ two: Int) -> Int? {
        
        let strategy = takeStrategy(one)
        
        if strategy.name != takeStrategy(two).name {
            return nil
        }
        
        return strategy.isSiblings(one, two)
    }
    
    private func takeStrategy(_ index: Int) -> MergingStrategy {
        
        return index > limitValue ? pot : fib
    }
}

class TutorialMergingStrategy : MergingStrategy {
    
    var name : MergingStrategyName = .Tutorial
    
    func prefilValues(maxIndex: Int) {
        
    }
    
    subscript(index: Int) -> Int {
        return index
    }
    
    func isSiblings(_ one: Int, _ two: Int) -> Int? {
        return nil
    }
}



