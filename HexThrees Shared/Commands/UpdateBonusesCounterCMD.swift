//
//  UpdateBonusesCounterCMD.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 28.08.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class UpdateBonusesCounterCMD : GameCMD {
    
    override func run() {
        
        for i in self.gameModel.bgHexes {
            if let bonus = i.bonus{
                
                if bonus.decCount() {
                    
                    i.removeBonusWithDisposeAnimation()
                }
            }
        }
    }
}
