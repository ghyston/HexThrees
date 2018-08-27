//
//  UpdateCellCMD.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 28.05.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class UpdateCellCMD : GameCMD {
    
    var cell : PlCellNode?
    var value : Int?
    
    func setup(cell: PlCellNode, value: Int) -> UpdateCellCMD {
        self.cell = cell
        self.value = value
        return self
    }
    
    override func run() {
        
        self.cell?.updateValue(
            value: self.value!,
            strategy: self.gameModel.strategy)
    }
    
}
