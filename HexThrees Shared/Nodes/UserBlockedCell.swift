//
//  UserBlockedCell.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 07.05.19.
//  Copyright © 2019 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

class UserBlockedCell : SKNode {
    
    let shap : SKShapeNode
    
    init(model : GameModel) {
        
        let path = model.geometry.outlinePath
        
        self.shap = model.geometry.createOutlineShape()
        super.init()
        
    }
    
    //@todo: why do we need all these coders?
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
