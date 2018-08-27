//
//  SwitchCellToNewParentCMD.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 28.05.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class SwitchParentsCMD : GameCMD {
    
    func run(from: BgCellNode, to: BgCellNode) {
        //@todo: after this do we need BGCell functions remove/add?
        from.gameCell?.removeFromParent()
        to.addGameCell(cell: from.gameCell!)
        from.gameCell = nil
    }
}
