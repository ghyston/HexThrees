//
//  DropRandomBonusCMD.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 27.08.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class DropRandomBonusCMD : GameCMD {
    
    override func run() {
        
        guard let randomFreeCell = self.gameModel.field.getBgCells(compare: HexField.freeCellWoBonuses).randomElement() else {
            return
        }
        
        let dropBonusProbability =
            Float(GameConstants.BaseBonusDropProbability) *
            Float(gameModel.turnsWithoutBonus)
        
        if Float.random > dropBonusProbability {
            
            gameModel.turnsWithoutBonus += 1
            return
        }
        
        gameModel.turnsWithoutBonus = 0
        
        let maxBonusesOnField = GameConstants.MaxBonusesOnScreen
        
        let bonusesOnField = self.gameModel.field.countBgCells(compare: { $0.bonus != nil })
        if bonusesOnField > maxBonusesOnField {
            return
        }
        
        let bonusTypes = ProbabilityArray<BonusType>()
        bonusTypes.add(.X2_POINTS, GameConstants.X2BonusProbability)
        bonusTypes.add(.X3_POINTS, GameConstants.X3BonusProbability)
        
        let blockedCellsCount = self.gameModel.field.countBgCells(compare: { $0.isBlocked })
        if blockedCellsCount > 1 {
            bonusTypes.add(.UNLOCK_CELL, GameConstants.UnlockBonusProbability)
        }
        else if blockedCellsCount == 1 {
            bonusTypes.add(.UNLOCK_CELL, GameConstants.LastBlockedUnlockBonusProbability)
        }
        
        if self.gameModel.field.countBgCells(compare: HexField.freeCell) > 2 {
            
            bonusTypes.add(.BLOCK_CELL, GameConstants.LockBonusProbability)
        }
       
        guard let bonusType = bonusTypes.getRandom() else {
            return
        }
        
        let bonusNode = BonusFabric.createBy(bonus: bonusType, gameModel: gameModel)
        randomFreeCell.addBonus(bonusNode)
    }
}
