//
//  PreviewVideoManager.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 07.12.20.
//  Copyright © 2020 Ilja Stepanow. All rights reserved.
//

import Foundation

class PreviewVideoManager
{
    static let initialCells : [(Int, Int)] = [(2,3), (2,4),(3,2),(4,2)]
    static let blockedCells : [(Int, Int)] = [(2,2), (4,3)]
    
    static func save1() -> SavedGame? {
        
        let cells : [SavedGame.SavedCell] = [
            SavedGame.SavedCell(exist: false, val: nil, blocked: true, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: false, val: nil, blocked: false, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: true, val: nil, blocked: false, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: true, val: 0, blocked: false, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: true, val: 1, blocked: false, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: false, val: nil, blocked: true, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: false, val: nil, blocked: true, bonusType: nil, bonusTurns: nil),
            
            SavedGame.SavedCell(exist: false, val: nil, blocked: true, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: false, val: nil, blocked: false, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: true, val: 2, blocked: false, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: true, val: 4, blocked: false, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: true, val: nil, blocked: true, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: false, val: nil, blocked: true, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: false, val: nil, blocked: true, bonusType: nil, bonusTurns: nil),
            
            SavedGame.SavedCell(exist: false, val: nil, blocked: true, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: true, val: nil, blocked: false, bonusType: BonusType.EXPAND_FIELD, bonusTurns: 1),
            SavedGame.SavedCell(exist: true, val: nil, blocked: true, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: true, val: 4, blocked: false, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: true, val: 1, blocked: true, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: false, val: nil, blocked: true, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: false, val: nil, blocked: true, bonusType: nil, bonusTurns: nil),
            
            SavedGame.SavedCell(exist: false, val: nil, blocked: true, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: true, val: nil, blocked: false, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: false, val: nil, blocked: true, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: false, val: nil, blocked: false, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: false, val: nil, blocked: true, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: false, val: nil, blocked: true, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: false, val: nil, blocked: true, bonusType: nil, bonusTurns: nil)
        ]
        
        let bonuses : [BonusType: SavedGame.CollectableBonusCodable] = [
            BonusType.COLLECTABLE_SWIPE_BLOCK : SavedGame.CollectableBonusCodable(currentValue: 1, maxValue: 4),
            BonusType.COLLECTABLE_PICK_UP : SavedGame.CollectableBonusCodable(currentValue: 2, maxValue: 4)
        ]
        
        return SavedGame(cells: cells, score: 28, maxFieldSize: 7, bonuses: bonuses)
    }
    
    static func save2() -> SavedGame? {
        
        let cells : [SavedGame.SavedCell] = [
            
            SavedGame.SavedCell(exist: false, val: nil, blocked: false, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: true, val: nil, blocked: true, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: true, val: nil, blocked: false, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: true, val: 0, blocked: false, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: true, val: nil, blocked: false, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: true, val: nil, blocked: false, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: false, val: nil, blocked: false, bonusType: nil, bonusTurns: nil),
            
            SavedGame.SavedCell(exist: false, val: nil, blocked: true, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: true, val: 0, blocked: false, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: true, val: 3, blocked: false, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: true, val: nil, blocked: true, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: true, val: 0, blocked: false, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: false, val: nil, blocked: true, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: false, val: nil, blocked: true, bonusType: nil, bonusTurns: nil),
            
            SavedGame.SavedCell(exist: true, val: nil, blocked: true, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: true, val: 2, blocked: false, bonusType: nil, bonusTurns: 1),
            SavedGame.SavedCell(exist: true, val: nil, blocked: false, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: true, val: 6, blocked: false, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: false, val: 1, blocked: true, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: false, val: nil, blocked: false, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: false, val: nil, blocked: false, bonusType: nil, bonusTurns: nil),
            
            SavedGame.SavedCell(exist: false, val: nil, blocked: true, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: true, val: 1, blocked: false, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: true, val: 7, blocked: false, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: true, val: 2, blocked: false, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: false, val: nil, blocked: true, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: false, val: nil, blocked: true, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: false, val: nil, blocked: true, bonusType: nil, bonusTurns: nil)
        ]
        
        let bonuses : [BonusType: SavedGame.CollectableBonusCodable] = [
            BonusType.COLLECTABLE_UNLOCK_CELL : SavedGame.CollectableBonusCodable(currentValue: 4, maxValue: 4),
            BonusType.COLLECTABLE_PAUSE_TIMER : SavedGame.CollectableBonusCodable(currentValue: 2, maxValue: 4),
            BonusType.COLLECTABLE_SWIPE_BLOCK : SavedGame.CollectableBonusCodable(currentValue: 3, maxValue: 4)
        ]
        
        return SavedGame(cells: cells, score: 315, maxFieldSize: 7, bonuses: bonuses)
    }
    
    static func save3() -> SavedGame? {
        
        let cells : [SavedGame.SavedCell] = [
            SavedGame.SavedCell(exist: false, val: nil, blocked: true, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: false, val: nil, blocked: true, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: false, val: nil, blocked: true, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: false, val: nil, blocked: true, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: true, val: nil, blocked: false, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: false, val: nil, blocked: true, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: false, val: nil, blocked: true, bonusType: nil, bonusTurns: nil),
            
            SavedGame.SavedCell(exist: false, val: nil, blocked: false, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: true, val: 0, blocked: false, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: true, val: 3, blocked: false, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: true, val: nil, blocked: true, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: false, val: nil, blocked: false, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: false, val: nil, blocked: false, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: false, val: nil, blocked: false, bonusType: nil, bonusTurns: nil),
            
            SavedGame.SavedCell(exist: false, val: nil, blocked: true, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: true, val: nil, blocked: false, bonusType: BonusType.EXPAND_FIELD, bonusTurns: 2),
            SavedGame.SavedCell(exist: true, val: 0, blocked: false, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: true, val: 0, blocked: false, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: false, val: 0, blocked: false, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: false, val: nil, blocked: true, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: false, val: nil, blocked: true, bonusType: nil, bonusTurns: nil),
            
            SavedGame.SavedCell(exist: false, val: nil, blocked: true, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: true, val: 5, blocked: false, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: true, val: 7, blocked: false, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: true, val: 4, blocked: false, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: false, val: 1, blocked: true, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: false, val: nil, blocked: false, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: false, val: nil, blocked: false, bonusType: nil, bonusTurns: nil),
            
            SavedGame.SavedCell(exist: true, val: 3, blocked: false, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: true, val: 5, blocked: false, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: true, val: 1, blocked: false, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: false, val: 2, blocked: false, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: false, val: nil, blocked: true, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: false, val: nil, blocked: true, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: false, val: nil, blocked: true, bonusType: nil, bonusTurns: nil),
            
            SavedGame.SavedCell(exist: false, val: nil, blocked: false, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: true, val: 0, blocked: false, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: true, val: 1, blocked: false, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: false, val: 2, blocked: false, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: false, val: nil, blocked: true, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: false, val: nil, blocked: true, bonusType: nil, bonusTurns: nil),
            SavedGame.SavedCell(exist: false, val: nil, blocked: true, bonusType: nil, bonusTurns: nil)
        ]
        
        let bonuses : [BonusType: SavedGame.CollectableBonusCodable] = [
            BonusType.COLLECTABLE_UNLOCK_CELL : SavedGame.CollectableBonusCodable(currentValue: 4, maxValue: 4),
            BonusType.COLLECTABLE_SWIPE_BLOCK : SavedGame.CollectableBonusCodable(currentValue: 1, maxValue: 4)
        ]
        
        return SavedGame(cells: cells, score: 281, maxFieldSize: 7, bonuses: bonuses)
    }

}
