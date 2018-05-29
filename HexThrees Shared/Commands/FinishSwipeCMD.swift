//
//  FinishSwipeCMD.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 29.05.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class FinishSwipeCMD : GameCMD {
    
    func runWithDelay(delay : Double) {
        
        Timer.scheduledTimer(
            timeInterval: delay,
            target: self,
            selector: #selector(FinishSwipeCMD.run), //@todo: good place to use common interface for GameCMD
            userInfo: nil,
            repeats: false)
    }
    
    @objc func run() {
        
        AddRandomCellCMD(gameModel).run()
        gameModel.swipeStatus.delay = 0.0
        gameModel.swipeStatus.inProgress = false
        
    }
}
