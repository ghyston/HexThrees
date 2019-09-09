//
//  AddCellByTimerCMD.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 09.09.19.
//  Copyright © 2019 Ilja Stepanow. All rights reserved.
//

import Foundation

class AddCellByTimerCMD : GameCMD {
    
    override func run() {
        
        var cells = self.gameModel.field.getBgCells(compare: HexField.freeCellWoBonuses)
        if cells.count == 0 {
            cells = self.gameModel.field.getBgCells(compare: HexField.freeCell)
        }
        
        guard let bgCell = self.gameModel.stressTimer.getCell() else {
            return
        }
        
        AddGameCellCMD(self.gameModel)
            .setup(addTo: bgCell)
            .run()
        
        if self.gameModel.stressTimer.isEnabled() {
            StartStressTimerCMD(self.gameModel).run()
        }
    }
}

