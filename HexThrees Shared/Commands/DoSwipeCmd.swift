//
//  DoSwipeCMD.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 13.06.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation
import os

class DoSwipeCmd : GameCMD {
    
    private var direction = SwipeDirection.Unknown
    
    func setup(direction : SwipeDirection) -> GameCMD {
        self.direction = direction
        return self
    }
    
    override func run() {
        guard let iterator = IteratorFabric.create(self.gameModel, direction) else {
            return
        }
        
        self.gameModel.swipeStatus.start()
        self.gameModel.hapticManager.warmup()
        
		os_signpost(.begin, log: .gestures, name: "moveLine")
        while let container = iterator.next() {
            MoveLineCMD(self.gameModel).setup(cells: container).run()
        }
		os_signpost(.end, log: .gestures, name: "moveLine")
        
        Timer.scheduledTimer(
            timeInterval: gameModel.swipeStatus.delay,
            target: self,
            selector: #selector(DoSwipeCmd.finishSwype),
            userInfo: nil,
            repeats: false)
    }
    
    @objc private func finishSwype() {
     
        gameModel.hapticManager.shutDown()
        gameModel.swipeStatus.finish()
    }
}
