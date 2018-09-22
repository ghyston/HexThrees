//
//  LineCellsContainerFabric.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 12.09.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class LineCellsContainerFabric {
    
    private static var containers = [LineCellsContainer]()
    
    static func fillWithXUp(gameModel : GameModel) -> [LineCellsContainer] {
        
        containers.removeAll(keepingCapacity: true)
        
        for i1 in 0 ..< gameModel.fieldHeight {
            
            let line = LineCellsContainer(gameModel)
            for i2 in 0 ..< gameModel.fieldWidth {
                //it should be i1 in fieldWidth ..< 0 but swift sucks
                let index = (i1 + 1) * gameModel.fieldWidth - i2 - 1
                line.add(index)
            }
            
            containers.append(line)
        }
        return containers
    }
    
    static func fillWithXDown(gameModel : GameModel) -> [LineCellsContainer] {
        
        containers.removeAll(keepingCapacity: true)
        let line = LineCellsContainer(gameModel)
        
        for i2 in 0 ..< gameModel.fieldHeight {
            
            for i1 in 0 ..< gameModel.fieldWidth {
                let index = i2 * gameModel.fieldWidth + i1
                line.add(index)
            }
            
            containers.append(line)
        }
        
        return containers
    }
    
    // @todo: use this iterators!!
    /*static func iterateXDown(
        gameModel: GameModel,
        newCell : (Int) -> Void,
        newLine : () -> Void) {
        
        for i2 in 0 ..< gameModel.fieldHeight {
            
            for i1 in 0 ..< gameModel.fieldWidth {
                let index = i2 * gameModel.fieldWidth + i1
                newCell(index)
            }
            
            newLine()
        }
    }*/
    
}
