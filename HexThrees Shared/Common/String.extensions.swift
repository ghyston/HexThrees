//
//  String.extensions.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 01.12.20.
//  Copyright © 2020 Ilja Stepanow. All rights reserved.
//

import Foundation

extension String {

    func localized(withComment comment: String? = nil) -> String {
        NSLocalizedString(self, comment: comment ?? "")
    }
    
    func localizedWithFormat(arguments: CVarArg...) -> String {
        String(format: self.localized(), arguments: arguments)
    }
}
