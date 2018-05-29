//
//  FinishSwipeCMD.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 29.05.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class FinishSwipeCMD : GameCMD {
    
    override func run() {
        
        AddRandomCellCMD(gameModel).run()
        gameModel.swipeStatus.delay = 0.0
        gameModel.swipeStatus.inProgress = false
        
    }
}
