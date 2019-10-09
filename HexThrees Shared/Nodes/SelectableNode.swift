//
//  HighlightableNode.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 07.10.19.
//  Copyright © 2019 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

protocol SelectableNode : class {
    
    // @todo: why I cant use private set in protocols?
    // @todo: how can I set default value in protocols?
    var canBeSelected : Bool { get set }
    func highlight()
    func shade() //@todo: rename to dim?
    func removeHighlight() //@todo: bad naming
}

extension SelectableNode where Self : HexNode {
    
    func highlight() {
        //self.hexShape.strokeColor = .white
        self.canBeSelected = true
        self.hexShape.lineWidth = 2
    }
    
    func shade() {
        //@todo
    }
    
    func removeHighlight() {
        self.canBeSelected = false
        self.hexShape.lineWidth = 0
        //@todo
    }
}
