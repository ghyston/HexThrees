//
//  UpdateScoreCMD.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 20.06.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class UpdateScoreCMD : GameCMD {
    
    func run(_ val : Int) {
    
        self.gameModel.score += val
        print("new score: \(self.gameModel.score)")
        
        if(self.gameModel.score > self.gameModel.newUnblockCellScore) {
            
            UnlockRandomCellCMD(self.gameModel).run()
            self.gameModel.newUnblockCellScore *= 10 //@todo: use some gamemechanics here
        }
        
    }
    
}
