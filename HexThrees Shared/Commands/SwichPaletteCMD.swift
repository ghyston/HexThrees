//
//  File.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 18.10.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class SwichPaletteCMD : GameCMD {
    
    override func run() {
        
        let pal : IPaletteManager = ContainerConfig.instance.resolve()
        pal.switchPalette(to: .Light)
        NotificationCenter.default.post(name: .swichPalette, object: nil)
    }
}
