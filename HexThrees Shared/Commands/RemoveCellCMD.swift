//
//  RemoveCellCMD.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 28.05.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class RemoveCellCMD : GameCMD {
    
    func run(cell: BgCell, delay: Double) {
        
        assert(cell.gameCell != nil, "RemoveCellCMD: BgCell is empty")
        
        cell.zPosition = 2 //@todo: define them as constants
        cell.gameCell?.removeFromParentWithDelay(delay: delay)
        cell.gameCell = nil
    }
}
