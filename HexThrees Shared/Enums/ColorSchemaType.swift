//
//  ColorSchemaType.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 16.12.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

enum ColorSchemaType: Int {
	case Dark = 1
	case Light = 2
	case Auto = 3
	
	func ensureDarkMode(_ traitCollection: UITraitCollection) -> ColorSchemaType {
		self == .Auto && traitCollection.userInterfaceStyle == .dark
		? .Dark
		: self == .Auto && traitCollection.userInterfaceStyle == .light
			? .Light
			: self;
	}
}


