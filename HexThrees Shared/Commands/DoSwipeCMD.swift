//
//  DoSwipeCMD.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 13.06.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class DoSwipeCMD : GameCMD {
    
    func run(direction : SwipeDirection) {
        
        if self.gameModel.swipeStatus.inProgress {
            return
        }
        
        self.gameModel.swipeStatus.inProgress = true
        self.gameModel.swipeStatus.somethingChangeed = false
        self.gameModel.hapticManager.warmup()

        if let iterator = IteratorFabric.create(self.gameModel, direction) {
            while let container = iterator.next() {
                MoveLineCMD(self.gameModel, cells: container).run()
            }
        }
        else {
            self.gameModel.swipeStatus.inProgress = false
        }
        
        Timer.scheduledTimer(
            timeInterval: gameModel.swipeStatus.delay,
            target: self,
            selector: #selector(DoSwipeCMD.finishSwype),
            userInfo: nil,
            repeats: false)
    }
    
    @objc private func finishSwype() {
     
        gameModel.hapticManager.shutDown()
        gameModel.swipeStatus.delay = 0.0
        gameModel.swipeStatus.inProgress = false
    }
}
