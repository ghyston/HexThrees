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
            motionBlur: params.motionBlur == MotionBlurStatus.Enabled,
            hapticFeedback: params.hapticFeedback == HapticFeedbackStatus.Enabled,
            timerEnabled: params.stressTimer == StressTimerStatus.Enabled)
        
        let fieldSize = self.params.fieldSize.rawValue
        
        gameModel.strategy.prefilValues(maxIndex:
            fieldSize * fieldSize)
        
        //@todo: logic here sucs!
        let existingBg = scene.childNode(withName: FieldOutline.defaultNodeName)
        let fieldBg = existingBg as? FieldOutline ?? FieldOutline()
        if existingBg == nil {
            scene.addChild(fieldBg)
        }
        
        fieldBg.name = FieldOutline.defaultNodeName
        fieldBg.recalculateFieldBg(model: gameModel)
        
        gameModel.field.addToScene(scene: scene)
        
        self.gameModel = gameModel
    }
}
