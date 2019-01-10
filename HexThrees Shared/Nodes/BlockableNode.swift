//
//  BlockableNode.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 04.12.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

protocol BlockableNode : class {
    
    var isBlocked: Bool { get set }
    var blockShader : SKShader { get set }
    var shape : SKShapeNode? { get set }
    
    func loadShader(shape: SKShapeNode)
    func block()
    func unblock()
}

extension BlockableNode where Self : SKNode {
    
    func loadShader(shape: SKShapeNode) {
        
        self.shape = shape
        self.blockShader = SKShader.init(fileNamed: "gridDervative.fsh")
    }
    
    func block() {
        
        self.shape?.fillShader = blockShader
        self.isBlocked = true
    }
    
    func unblock() {
        
        self.shape?.fillShader = nil
        self.isBlocked = false
    }
}
