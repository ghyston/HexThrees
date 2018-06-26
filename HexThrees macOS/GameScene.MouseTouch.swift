//
//  GameScene.MouseTouch.swift
//  HexThrees macOS
//
//  Created by Ilja Stepanow on 30.05.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

#if os(OSX)
// Mouse-based event handling
extension GameScene {
    
    override func mouseDown(with event: NSEvent) {
        
        let coord = event.location(in: self)
        /*if self.gameModel?.swipeStatus.inProgress ?? true {
            return
        }*/
        
        //@todo: check direction and call DoSwipeCMD
        
        /*self.gameModel?.swipeStatus.inProgress = true
        
        if coord.x < -500 {
            MoveLeftCMD(self.gameModel!).run()
        }
        else if coord.x > 500 {
            MoveRightCMD(self.gameModel!).run()
        } else if coord.x < 0 && coord.y < 0 {
            MoveXDownCMD(self.gameModel!).run()
        }
        else if coord.x < 0 && coord.y > 0 {
            MoveYUpCMD(self.gameModel!).run()
        }
        else if coord.x > 0 && coord.y < 0 {
            MoveYDownCMD(self.gameModel!).run()
        }
        else if coord.x > 0 && coord.y > 0 {
            MoveXUpCMD(self.gameModel!).run()
        }
        
        FinishSwipeCMD(self.gameModel!).runWithDelay(delay: gameModel?.swipeStatus.delay ?? 0.0)*/
        
    }
}
#endif
