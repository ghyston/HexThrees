//
//  EndCellSelectionCMD.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 08.10.19.
//  Copyright © 2019 Ilja Stepanow. All rights reserved.
//

import Foundation

class EndCellSelectionCMD : GameCMD {
    
    private func removeHighlight(node: BgCell) {
        node.removeHighlight()
    }
    
    override func run() {
        gameModel.field.executeForAll(lambda: self.removeHighlight)
        StartStressTimerCMD(self.gameModel).run()
        gameModel.swipeStatus.unlockSwipes()
    }
}
