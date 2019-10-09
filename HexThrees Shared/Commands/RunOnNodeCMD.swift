//
//  RunOnNodeCMD.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 09.10.19.
//  Copyright © 2019 Ilja Stepanow. All rights reserved.
//

import Foundation

class RunOnNodeCMD : GameCMD {
    
    var node: BgCell?
    
    func setup(node : BgCell) -> RunOnNodeCMD {
        self.node = node
        return self
    }
}
