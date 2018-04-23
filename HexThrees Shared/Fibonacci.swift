//
//  Fibonacci.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 23.04.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

func isSiblings(_ one: Int, _ two: Int) -> Int? {
    
    // Straightforward algorithm. @todo: Rewrite with some hash/cache
    
    let minVal = min(one, two)
    let maxVal = max(one, two)
    
    let first = 0
    let second = 1
    
    var Nm1 = second    //N minus 1
    var Nm2 = first     //N minus 2
    var N = second + first
    
    while N < minVal {
        
        Nm2 = Nm1
        Nm1 = N
        N = Nm1 + Nm2
    }
    
    if (N != minVal) || (maxVal != (N + Nm1)) {
        return nil
    }
    
    return one + two
}
