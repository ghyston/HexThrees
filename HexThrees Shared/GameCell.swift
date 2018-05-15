//
//  GameCell.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 26.04.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

class GameCell : HexCell {
    
    var value: Int
    var newParent : BgCell?
    
    init(val: Int) {
        self.value = val
        
        super.init(text: "\(val)", isGray: false)
    }
    
    func playAppearAnimation() {
        self.setScale(0.01)
        self.run(SKAction.scale(to: 1.0, duration: 0.5))
    }
    
    func playUpdateAnimation() {
        
        let zoomIn = SKAction.scale(to: 1.5, duration: 0.3)
        let zoomOut = SKAction.scale(to: 1.0, duration: 0.2)
        self.run(SKAction.sequence([zoomIn, zoomOut]))
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
    
    func updateValue(_ val: Int) {
        self.value = val //@todo: setter
        self.updateText(text: "\(val)")
        self.playUpdateAnimation() //@todo: should it be called from outside?
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
