//
//  RequestStoreProductCMD.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 27.10.20.
//  Copyright © 2020 Ilja Stepanow. All rights reserved.
//

import Foundation

class RequestStoreProductCMD : GameCMD {
	override func run() {
		guard !self.gameModel.purchased else {
			return
		}
		
		IAPHelper.shared.updateProducts()
	}
}
