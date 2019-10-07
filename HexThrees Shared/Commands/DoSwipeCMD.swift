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

        guard let iterator = IteratorFabric.create(self.gameModel, direction) else {
            return
        }
        
        self.gameModel.swipeStatus.start()
        self.gameModel.hapticManager.warmup()
        
        while let container = iterator.next() {
            MoveLineCMD(self.gameModel, cells: container).run()
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
        gameModel.swipeStatus.finish()
    }
}
