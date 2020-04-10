//
//  File.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 18.10.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class SwitchPaletteCMD: GameCMD {
	func run(_ palette: ColorSchemaType) {
		let pal: IPaletteManager = ContainerConfig.instance.resolve()
		pal.switchPalette(to: palette)
		NotificationCenter.default.post(name: .switchPalette, object: nil)
	}
}
