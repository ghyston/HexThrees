//
//  StartGameCMD.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 25.06.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

class StartGameCMD : GameCMD {
    
    func run(scene: GameScene, view: SKView, params: GameParams, tempAddRandomStaff: Bool) {
    
        for i2 in 0 ..< params.fieldSize {
            for i1 in 0 ..< params.fieldSize {
                
                AddBgCellCMD(gameModel).run(
                    scene: scene,
                    coord: AxialCoord(i2, i1))
            }
        }
        
        //DebugPaletteCMD(self.gameModel!).run()
        
        //@todo: remove that!!!
        if(tempAddRandomStaff) {
            
            for _ in 0 ..< params.randomElementsCount {
                
                AddRandomCellCMD(gameModel).runWithDelay(delay: Double.random)
            }
            
            for _ in 0 ..< params.blockedCellsCount {
                
                BlockRandomCellCMD(gameModel).run()
            }
        }
    }
}
