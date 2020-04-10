//
//  RestartGame.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 01.07.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

class CleanGameCmd : GameCMD {
    
    override func run() {
        
        self.gameModel.field.clean()
    }
}
