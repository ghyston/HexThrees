//
//  SelectHapticFeedbackCMD.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 14.01.19.
//  Copyright © 2019 Ilja Stepanow. All rights reserved.
//

import Foundation

class SelectHapticFeedbackCMD : GameCMD {
    
    override func run(){
        gameModel.hapticManager.select()
    }
}
