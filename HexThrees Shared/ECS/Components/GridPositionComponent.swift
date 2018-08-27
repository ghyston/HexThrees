//
//  GridPositionComponent.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 26.08.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation
import GameKit

class GameGridPositionComponent : GKComponent {
    
    let position : AxialCoord
    
    init(_ position: AxialCoord) {
        self.position = position
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
