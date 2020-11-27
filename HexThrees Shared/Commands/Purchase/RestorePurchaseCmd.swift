//
//  RestorePurchaseCmd.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 13.10.20.
//  Copyright © 2020 Ilja Stepanow. All rights reserved.
//

import Foundation

class RestorePurchaseCmd: GameCMD {
	override func run () {
		IAPHelper.shared.restore()
	}
}
