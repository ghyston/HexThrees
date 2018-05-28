//
//  UpdateCellCMD.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 28.05.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class UpdateCellCMD : GameCMD {
    
    func run(cell: GameCell, value: Int, delay: Double) {
        
        cell.updateValue(value, delay: delay)
    }
    
}
