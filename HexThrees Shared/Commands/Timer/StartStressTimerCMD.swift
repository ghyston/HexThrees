//
//  StartTimerCMD.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 09.05.19.
//  Copyright © 2019 Ilja Stepanow. All rights reserved.
//

import Foundation

class StartStressTimerCMD : GameCMD {
    
    override func run() {
        
        guard gameModel.stressTimer.isEnabled() else {
            return
        }
        
        var cells = self.gameModel.field.getBgCells(compare: HexField.freeCellWoBonuses)
        if cells.count == 0 {
            cells = self.gameModel.field.getBgCells(compare: HexField.freeCell)
        }
        
        guard let bgCell = cells.randomElement() else {
            return
        }
        
        bgCell.startCircleAnimation()
        
        
        self.gameModel.stressTimer.startNew(
            timer: AddCellByTimerCMD(self.gameModel)
                .runWithDelay(delay: GameConstants.StressTimerInterval),
            cell: bgCell)
        
        
        //@todo: remove this notification type
        /*NotificationCenter.default.post(
            name: .startTimer,
            object: nil)*/
    }
}
