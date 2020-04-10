//
//  FieldSize.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 16.12.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

enum FieldSize: Int, Codable {
	case Thriple = 3
	case Quaddro = 4
	case Pento = 5

	var cellsCount: Int {
		return self.rawValue * self.rawValue
	}
}
