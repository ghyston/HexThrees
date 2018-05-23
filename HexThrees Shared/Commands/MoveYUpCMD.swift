//
//  MoveYUpCMD.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 23.05.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class MoveYUpCMD : GameCMD {
    
    func run() {
        
        for i1 in 0 ..< self.gameModel.fieldWidth {
            var line = Array<BgCell>()
            for i2 in 0 ..< self.gameModel.fieldHeight {
                //it should be i1 in fieldWidth ..< 0 but swift sucks
                let index = (self.gameModel.fieldHeight - i2 - 1) * self.gameModel.fieldWidth + i1
                line.append(self.gameModel.bgHexes[index])
            }
            
            MoveLineCMD(self.gameModel).run(cells: line)
        }
    }
}
