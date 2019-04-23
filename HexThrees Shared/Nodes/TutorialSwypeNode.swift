//
//  TutorialSwypeNode.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 04.04.19.
//  Copyright © 2019 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

class TutorialSwipeNode : SKNode {
    
    var fieldOutline : FieldOutline
    
    init(model: GameModel, width: CGFloat, scene: SKScene) {
        
        self.fieldOutline = FieldOutline()
        self.fieldOutline.recalculateFieldBg(model: model)
        
        super.init()
        
        addChild(self.fieldOutline)
        
        for i2 in 0 ..< model.fieldWidth {
            for i1 in 0 ..< model.fieldHeight {
                
                AddBgCellCMD(model).run(
                    scene: scene,
                    coord: AxialCoord(i2, i1))
            }
        }
        
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
