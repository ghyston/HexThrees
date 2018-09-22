//
//  DropRandomBonusCMD.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 27.08.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class DropRandomBonusCMD : GameCMD {
    
    private func freeCell(cell: BgCell) -> Bool {
        
        return
            cell.gameCell == nil &&
            cell.isBlocked == false &&
            cell.bonus == nil
    }
    
    private func cellIsBlocked(cell: BgCell) -> Bool {
        
        return cell.isBlocked
    }
    
    private func cellHasBonus(cell: BgCell) -> Bool {
        
        return cell.bonus != nil
    }
    
    override func run() {
        
        guard let randomFreeCell = self.gameModel.getBgCells(compare: self.freeCell).randomElement() else {
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
        
        let bonusesOnField = self.gameModel.countBgCells(compare: self.cellHasBonus)
        if bonusesOnField > maxBonusesOnField {
            return
        }
        
        let bonusTypes = ProbabilityArray<BonusType>()
        bonusTypes.add(.X2_POINTS, GameConstants.X2BonusProbability)
        bonusTypes.add(.X3_POINTS, GameConstants.X3BonusProbability)
        
        if self.gameModel.hasBgCells(compare: self.cellIsBlocked) {
            
            bonusTypes.add(.UNLOCK_CELL, GameConstants.UnlockBonusProbability)
        }
        
        if self.gameModel.countBgCells(compare: self.freeCell) > 2 {
            
            bonusTypes.add(.BLOCK_CELL, GameConstants.LockBonusProbability)
        }
       
        guard let bonusType = bonusTypes.getRandom() else {
            return
        }
        
        let bonusNode = BonusFabric.createBy(bonus: bonusType, gameModel: gameModel)
        randomFreeCell.addBonus(bonusNode)
    }
}
