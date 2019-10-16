//
//  ApplyScoreBuff.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 31.08.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class ApplyScoreBuffCmd : GameCMD {
    
    private func buffStillAlive(buff: ScoreBuff) -> Bool {
        return buff.turnsToApply > 0
    }
    
    
    override func run() {
                
        var buffs = self.gameModel.scoreBuffs.filter(self.buffStillAlive)
        
        let oldScore = self.gameModel.scoreMultiplier
        self.gameModel.recalculateScoreBaff()
        let newScore = self.gameModel.scoreMultiplier
        
        if oldScore != newScore {
            NotificationCenter.default.post(
                name: .scoreBuffUpdate,
                object: newScore)
        }
        
        for (index, _) in buffs.enumerated() {
            buffs[index].turnsToApply -= 1
        }
        self.gameModel.scoreBuffs = buffs
    }
}
