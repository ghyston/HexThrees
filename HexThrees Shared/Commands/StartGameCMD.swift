//
//  StartGameCMD.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 25.06.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

class StartGameCMD : CMD {
    
    let scene : SKScene
    let view : SKView
    let params : GameParams
    var gameModel : GameModel?
    
    init(scene: SKScene, view: SKView, params: GameParams) {
        
        self.scene = scene
        self.view = view
        self.params = params
    }
    
    func run() {
    
        let gameModel = GameModel(            
            screenWidth: view.frame.width,
            fieldSize: params.fieldSize.rawValue,
            strategy: MerginStrategyFabric.createByName(params.strategy),
            motionBlur: params.motionBlur == MotionBlurStatus.Enabled)
        
        let fieldSize = self.params.fieldSize.rawValue
        
        gameModel.strategy.prefilValues(maxIndex:
            fieldSize * fieldSize)
        
        let fieldBg = FieldOutline()
        fieldBg.name = FieldOutline.defaultNodeName
        fieldBg.recalculateFieldBg(model: gameModel)
        scene.addChild(fieldBg)
        
        for i2 in 0 ..< fieldSize {
            for i1 in 0 ..< fieldSize {
                
                AddBgCellCMD(gameModel).run(
                    scene: scene,
                    coord: AxialCoord(i2, i1))
            }
        }
        
        self.gameModel = gameModel
    }
}
