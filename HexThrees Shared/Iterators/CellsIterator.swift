//
//  CellsIterator.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 27.09.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

protocol CellsIterator {
    
    func next() -> LineCellsContainer2?
}

class BaseCellsIterator {
    
    internal let gameModel : GameModel
    internal var line = LineCellsContainer2()
    
    internal var y: Int = 0
    internal var x: Int = 0
    internal var w: Int { return self.gameModel.fieldWidth }
    internal var h: Int { return self.gameModel.fieldHeight }
    
    init(_ gameModel: GameModel) {
        
        self.gameModel = gameModel
    }
    
    internal func getCell(_ x: Int, _ y: Int) -> BgCell {
        
        let index = y * w + x
        return self.gameModel.bgHexes[index]
    }
}
