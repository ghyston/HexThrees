//
//  NodeComponent.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 26.08.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation
import GameKit

class ValueComponent : GKComponent {
    
    var value : Int
    
    init(value: Int) {
        
        self.value = value
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
