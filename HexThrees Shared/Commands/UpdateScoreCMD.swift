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
        NotificationCenter.default.post(
            name: .updateScore,
            object: self.gameModel.score)
    }
    
}
