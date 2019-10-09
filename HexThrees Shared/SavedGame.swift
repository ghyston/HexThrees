//
//  SavedGame.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 06.07.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

struct SavedGame : Codable{
    
    struct SavedCell : Codable {
        
        let val : Int?
        let blocked: Bool
        let bonusType: BonusType?
        let bonusTurns: Int?
    }
    
    let cells: [SavedCell]
    let score: Int
    let fieldSize: FieldSize //@todo: save and check for validation on load!
}
