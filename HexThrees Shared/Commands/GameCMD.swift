//
//  GameCMD.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 23.05.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

@objc protocol CMD {
    @objc func run()
}

extension CMD {
    
    func runWithDelay(delay : Double) -> Timer {
        
        return Timer.scheduledTimer(
            timeInterval: delay,
            target: self,
            selector: #selector(CMD.run),
            userInfo: nil,
            repeats: false)
    }
}

class GameCMD : CMD {
    
    let gameModel: GameModel
    init(_ gameModel: GameModel) {
        self.gameModel = gameModel
    }
    
    @objc func run() {
        assert(false, "GameCMD should not be run")
    }
}

