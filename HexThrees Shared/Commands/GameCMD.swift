//
//  GameCMD.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 23.05.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

protocol CMD {
    func run()
}

//@todo: Swift: abstract classes to implement CMD properly?
class GameCMD {
    
    let gameModel: GameModel
    init(_ gameModel: GameModel) {
        self.gameModel = gameModel
    }
}
