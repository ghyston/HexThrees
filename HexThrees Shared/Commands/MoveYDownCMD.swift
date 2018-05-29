//
//  MoveYDownCMD.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 23.05.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class MoveYDownCMD : GameCMD {
    
    override func run() {
        for i1 in 0 ..< self.gameModel.fieldWidth {
            var line = Array<BgCell>()
            for i2 in 0 ..< self.gameModel.fieldHeight {
                let index = i2 * self.gameModel.fieldWidth + i1
                line.append(self.gameModel.bgHexes[index])
            }
            
            MoveLineCMD(self.gameModel).run(cells: line)
        }
    }
}
