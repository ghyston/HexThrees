//
//  TutorialSwypeNode.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 04.04.19.
//  Copyright © 2019 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

class HelpSwipeNode : SKNode {
    
    var fieldOutline : FieldOutline
    
    init(model: GameModel, width: CGFloat, scene: SKScene) {
        
        self.fieldOutline = FieldOutline()
        self.fieldOutline.recalculateFieldBg(model: model)
        
        super.init()
        
        addChild(self.fieldOutline)
        
        let addToScene : (_ : BgCell) -> Void = { self.scene?.addChild($0) }
        model.field.executeForAll(lambda: addToScene)
        
        for _ in 0 ... 4 {
            AddRandomCellCMD(model)
                .forTutorial()
                .run()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
