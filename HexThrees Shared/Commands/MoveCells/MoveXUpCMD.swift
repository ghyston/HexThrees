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
        
        let lines = LineCellsContainerFabric.fillWithXUp(gameModel: self.gameModel)
        
        for line in lines {
            line.flush()
        }
    }
    
    
    
}
