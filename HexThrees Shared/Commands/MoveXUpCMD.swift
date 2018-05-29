//
//  MoveXUpCMD.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 23.05.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class MoveXUpCMD : GameCMD {
    
    override func run() {
        for i1 in 0 ..< self.gameModel.fieldHeight {
            var line = Array<BgCell>()
            for i2 in 0 ..< self.gameModel.fieldWidth {
                //it should be i1 in fieldWidth ..< 0 but swift sucks
                let index = (i1 + 1) * self.gameModel.fieldWidth - i2 - 1
                line.append(self.gameModel.bgHexes[index])
            }
            
            MoveLineCMD(self.gameModel).run(cells: line)
        }
    }
    
}
