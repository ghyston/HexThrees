//
//  SKNode.extensions.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 10.12.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

extension SKNode {
    
    func runForAllSubnodes(lambda: (_: SKNode) -> Void) {
        
        lambda(self)
        for child in self.children {
            child.runForAllSubnodes(lambda: lambda)
        }
    }
}
