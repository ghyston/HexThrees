//
//  RestartGame.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 01.07.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class CleanGameCMD : GameCMD {
    
    override func run() {
        
        for bgCell in self.gameModel.bgHexes {
            
            bgCell.removeFromParent()
        }
        self.gameModel.bgHexes.removeAll()
        self.gameModel.score = 0
    }
}
