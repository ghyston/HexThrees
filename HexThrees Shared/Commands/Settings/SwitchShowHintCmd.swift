//
//  SwitchShowHintCmd.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 03.12.20.
//  Copyright © 2020 Ilja Stepanow. All rights reserved.
//

import Foundation

class SwitchShowHintCmd: GameCMD {
    func run(isOn: Bool) {
        self.gameModel.showHint = isOn
        NotificationCenter.default.post(name: .switchShowHint, object: isOn)
        
        let showHintStatus = isOn
            ? ShowHintStatus.Enabled
            : ShowHintStatus.Disabled
        
        UserDefaults.standard.set(showHintStatus.rawValue, forKey: SettingsKey.ShowHint.rawValue)
    }
}
