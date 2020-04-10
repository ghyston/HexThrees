//
//  SwipeBlockCmd.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 02.04.20.
//  Copyright © 2020 Ilja Stepanow. All rights reserved.
//

import Foundation

class SwipeBlockCmd: RunOnNodeCMD {
	override func run() {
		self.node?.blockFromSwipe()
	}
}
