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
        assert(gameModel.bgHexes.count == gameSave.cells.count, "on load game configs are different")
        
        for i in 0..<gameSave.cells.count {
            
            if gameSave.cells[i].blocked {
                
                gameModel.bgHexes[i].block()
            }
            else if gameSave.cells[i].val != nil {
                
                let newElement = GameCell(
                    model: self.gameModel,
                    val: gameSave.cells[i].val!)
                gameModel.bgHexes[i].addGameCell(cell: newElement)
                newElement.playAppearAnimation()
            }
        }
        gameModel.score = gameSave.score
    }
    
}
