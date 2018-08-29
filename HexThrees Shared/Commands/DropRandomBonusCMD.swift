//
//  DropRandomBonusCMD.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 27.08.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class DropRandomBonusCMD : GameCMD {
    
    private func cellForBonus(cell: BgCell) -> Bool {
        
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
        
        //@todo: add random generator with probabilities etc
        
        var freeCells = self.gameModel.getBgCells(compare: self.cellForBonus)
        
        guard freeCells.count > 0 else {
            return
        }
        
        let random = Int.random(min: 0, max: freeCells.count - 1)
        
        let dropBonusProbability =
            Float(GameConstants.BaseBonusDropProbability) *
            Float(gameModel.turnsWithoutBonus)
        let rand = Float.random
        if rand > dropBonusProbability {
            
            gameModel.turnsWithoutBonus += 1
            return
        }
        
        gameModel.turnsWithoutBonus = 0
        
        let maxBonusesOnField = GameConstants.MaxBonusesOnScreen
        
        let bonusesOnField = self.gameModel.countBgCells(compare: self.cellHasBonus)
        if bonusesOnField > maxBonusesOnField {
            return
        }
        
        let hasBlockedCells = self.gameModel.hasBgCells(compare: self.cellIsBlocked)
        
        let blockBonusProbability: Float = hasBlockedCells ? 0.5 : 0.0
        let unlockBonusProbability: Float = 0.5
        
        let bonusDice = Float.random(
            min: 0.0,
            max: Float(blockBonusProbability + unlockBonusProbability))
        
        //@todo: check, this is actually wrong!
        if(bonusDice < blockBonusProbability) {
            
            let bonusNode = BonusFabric.createLockBonus(gameModel: self.gameModel)
            freeCells[random].addBonus(bonusNode)
        }
        else {
            
            let bonusNode = BonusFabric.createUnlockBonus(gameModel: self.gameModel)
            freeCells[random].addBonus(bonusNode)
        }
    }
}
