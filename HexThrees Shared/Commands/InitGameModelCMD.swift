//
//  InitGameModelCMD.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 26.08.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation
import GameKit
import SpriteKit

class InitGameModelCMD : CMD {
    
    let view : SKView
    let params : GameParams
    
    init(view: SKView, params: GameParams) {
        
        self.view = view
        self.params = params
    }
    
    func run() {
        
        let gameModel = GameModel(
            screenWidth: view.frame.width,
            fieldSize: params.fieldSize,
            strategy: MerginStrategyFabric.createByName(params.strategy))
        
        gameModel.strategy.prefilValues(maxIndex: self.params.fieldSize * self.params.fieldSize)
        
        ContainerConfig.instance.register(gameModel as GameModel)
    }
    
}
