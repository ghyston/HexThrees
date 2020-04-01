//
//  SelectCellCMD.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 09.10.19.
//  Copyright © 2019 Ilja Stepanow. All rights reserved.
//

import Foundation

class TouchSelectableCellCmd : RunOnNodeCMD {
    
    override func run() {
        
        if  node == nil ||
            node?.canBeSelected == false ||
            self.gameModel.selectedBonusType == nil ||
            self.gameModel.selectCMD == nil {
            return;
        }
        
        let bonusType = self.gameModel.selectedBonusType!
        NotificationCenter.default.post(name: .useCollectables, object: bonusType)
        self.gameModel.collectableBonuses[bonusType]?.use()
        self.gameModel.selectCMD?.setup(node: node!).run()
		self.gameModel.selectedBonusType = nil
        EndCellSelectionCMD(self.gameModel).run()
    }
}
