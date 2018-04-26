//
//  GameCell.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 26.04.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class GameCell : HexCell {
    
    var value: Int
    var newParent : BgCell?
    
    init(val: Int) {
        self.value = val
        
        super.init(text: "\(val)", isGray: false)
    }
    
    // this is because SKAction selector cannot take arguments (or I dotn know how)
    @objc func switchToNewParent() {
        (self.parent as? BgCell)?.removeGameCell()
        newParent?.addGameCell(cell: self)
        newParent = nil
    }
    
    @objc func resetCoordinates() {
        self.position = CGPoint(x: 0, y: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
