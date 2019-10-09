//
//  SelectNodeCMD.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 07.10.19.
//  Copyright © 2019 Ilja Stepanow. All rights reserved.
//

import Foundation

class StartCellSelectionCMD : GameCMD {
    
    var comparator: (_: BgCell) -> Bool
    var onSelectCmd: RunOnNodeCMD //@todo: 
    
    init(gameModel: GameModel,
         comparator: @escaping (_: BgCell) -> Bool,
         onSelect: RunOnNodeCMD) {
        self.comparator = comparator
        self.onSelectCmd = onSelect
        super.init(gameModel)
    }
    
    private func toggleHighlight(node: BgCell) {
        if comparator(node) {
            node.highlight()
        }
        else {
            node.shade()
        }
    }
    
    override func run() {
        RollbackTimerCMD(self.gameModel).run()
        gameModel.field.executeForAll(lambda: self.toggleHighlight)
        self.gameModel.selectCMD = onSelectCmd
        self.gameModel.swipeStatus.lockSwipes()
    }
}
