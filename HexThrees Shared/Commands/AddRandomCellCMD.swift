//
//  AddRandomCellCMD.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 23.05.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class AddRandomCellCMD : GameCMD {
    
    internal var isTutorial : Bool = false
    internal var autoRepeat : Bool = true
    
    override func run() {
        
        let cells = self.gameModel.field.getBgCellsWithPriority(
            required: HexField.freeCell,
            priority: HexField.freeCellWoBonuses, HexField.cellWoShader)
        
        guard let bgCell = cells.randomElement() else {
            return
        }
        
        AddGameCellCMD(self.gameModel)
            .setup(addTo: bgCell)
            .run()
        
        /*if self.gameModel.stressTimer.isEnabled() && autoRepeat{
            StartStressTimerCMD(self.gameModel).run()
        }*/
    }
}
