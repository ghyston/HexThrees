//
//  RestartGame.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 01.07.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

class CleanGameCMD : GameCMD {
    
    private func removeCellFromField(cell: BgCell) {
        cell.removeFromParent()
    }
    
    override func run() {
        self.gameModel.field.executeForAll(lambda: self.removeCellFromField)
        self.gameModel.field.clean()
        self.gameModel.score = 0
    }
}
