//
//  ContainComponent.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 27.08.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation
import GameKit

class ContentComponent : GKComponent {
    
    var content: GKEntity?
    
    @objc func addContent(content: GKEntity) {
        
        assert(self.content == nil, "ContentComponent already contain")
        
        self.content = content
        
        guard let selfNode = self.entity?.component(ofType: GKSKNodeComponent.self) else {
            return
        }
        
        guard let contentNode = contentNode.component(ofType: GKSKNodeComponent.self) else {
            return
        }
        
        selfNode.node.addChild(contentNode)
        //self.gameCell?.zPosition = zPositions.bgCellZ.rawValue
    }
    
    @objc func removeGameCell() {
        
        contentNode
            .component(ofType: GKSKNodeComponent.self)?
            .removeFromParent()
        
        self.content = nil
    }
}
