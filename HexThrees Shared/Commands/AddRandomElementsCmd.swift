//
//  AddRandomElementsCMD.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 30.10.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class AddRandomElementsCmd: GameCMD {
	private var cells: Int = 0
	private var blocked: Int = 0
	
	func setup(_ cells: Int, _ blocked: Int) -> GameCMD {
		self.cells = cells
		self.blocked = blocked
		return self
	}
	
	override func run() {
		for _ in 0 ..< cells {
			_ = CmdFactory()
				.AddRandomCellSkipRepeat()
				.runWithDelay(delay: Double.random)
		}
		
		for _ in 0 ..< blocked {
			CmdFactory().BlockRandomCell().run()
		}
	}
}
