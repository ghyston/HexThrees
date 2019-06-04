//
//  AddRandomCellForTutorialCMD.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 23.04.19.
//  Copyright © 2019 Ilja Stepanow. All rights reserved.
//

import Foundation

extension AddRandomCellCMD {
    
    func forTutorial() -> AddRandomCellCMD {
        
        isTutorial = true
        return self
    }
    
    func skipRepeat() -> AddRandomCellCMD {
        
        autoRepeat = false
        return self
    }
}
