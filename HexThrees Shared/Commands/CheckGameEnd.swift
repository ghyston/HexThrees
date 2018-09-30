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
        
        //@todo: this is pseudo code to check lines using iterators
        /*var iterator = MoveLeftIterator(self.gameModel)
         while var container = iterator.next() {
         
         if container.canBeMerged { //@todo: implement this
         return true
         }
         }
         return false*/
        // end of pseudo code
        
        
        
        
    }
    
    //func checkLine(Array<BgCell>)
    
}
