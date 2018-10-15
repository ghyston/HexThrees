//
//  ApplyScoreBuff.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 31.08.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class ApplyScoreBuffCMD : GameCMD {
    
    private func buffStillAlive(buff: ScoreBuff) -> Bool {
        
        return buff.turnsToApply > 0
    }
    
    //@todo: this is not tested, because Dammtor is next
    override func run() {
                
        let buffs =
         self.gameModel.scoreBuffs.filter(self.buffStillAlive)
        
        var scoreMultiplier = 1
        for var buff in buffs {
            
            buff.turnsToApply -= 1
            scoreMultiplier *= buff.factor
        }
        
        self.gameModel.scoreMultiplier = scoreMultiplier
        self.gameModel.scoreBuffs = buffs
    }
}
