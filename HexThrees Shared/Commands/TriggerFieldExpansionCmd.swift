//
//  IncreaseFieldSize.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 27.04.20.
//  Copyright © 2020 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

class TriggerFieldExpansionCmd: GameCMD {
	override func run() {
		NotificationCenter.default.post(name: .expandField, object: nil)
	}
}
