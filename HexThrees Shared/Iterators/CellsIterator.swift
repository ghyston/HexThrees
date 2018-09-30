//
//  CellsIterator.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 27.09.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

protocol CellsIterator {
    
    func next() -> LineCellsContainer2?
}
