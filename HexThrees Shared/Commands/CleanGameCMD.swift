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
    
    override func run() {
        
        self.gameModel.field.clean()
        //@todo: check, do we need to reset score, if we create model afterwards anyway?
        self.gameModel.score = 0
    }
}
