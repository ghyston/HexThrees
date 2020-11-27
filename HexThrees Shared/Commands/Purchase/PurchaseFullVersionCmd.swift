//
//  DoPurchaseCmd.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 05.06.20.
//  Copyright © 2020 Ilja Stepanow. All rights reserved.
//

import Foundation

class PurchaseFullVersionCmd : GameCMD {
	override func run() {
		IAPHelper.shared.buy()
	}
}
