//
//  CheckGameEnd.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 04.07.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class CheckGameEnd : GameCMD {
    
    override func run() {
        
        //First, check is there any free space
        for i in self.gameModel.bgHexes {
            if(i.gameCell == nil && i.isBlocked == false) {
                return
            }
        }
        
        
        
        
    }
    
    //func checkLine(Array<BgCell>)
    
}
