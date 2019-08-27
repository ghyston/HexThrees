//
//  LoadGameCMD.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 06.07.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class LoadGameCMD: GameCMD {
    
    func run(_ gameSave : SavedGame) {
        //@todo: remove assets from final build, make soft loading,
        assert(gameModel.field.width * gameModel.field.height == gameSave.cells.count, "on load game configs are different")
        
        for i in 0..<gameSave.cells.count {
            
            let loadedCell = gameSave.cells[i]
            
            if loadedCell.blocked {
                
                gameModel.field[i].block()
            }
            else if let val = loadedCell.val {
                
                let newElement = GameCell(
                    model: self.gameModel,
                    val: val)
                gameModel.field[i].addGameCell(cell: newElement)
                newElement.playAppearAnimation()
            }
            else if let bonusType = loadedCell.bonusType {
                
                let bonusNode = BonusFabric.createBy(bonus: bonusType, gameModel: self.gameModel)
                
                if let bonusTurns = loadedCell.bonusTurns {
                    bonusNode.turnsCount = bonusTurns
                }
                
                gameModel.field[i].addBonus(bonusNode)
            }
        }
        gameModel.score = gameSave.score
        NotificationCenter.default.post(
            name: .updateScore,
            object: self.gameModel.score)
    }
    
}
