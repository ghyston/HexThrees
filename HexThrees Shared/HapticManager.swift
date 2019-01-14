//
//  HapticManager.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 14.01.19.
//  Copyright © 2019 Ilja Stepanow. All rights reserved.
//

import Foundation

protocol IHapticManager {
    
    var isEnabled: Bool { get set }
    
    func warmup()
    func shutDown()
    func impact()
    func select()
}

class HapticManager : IHapticManager {
    
    var isEnabled: Bool
    var selectGenerator: UISelectionFeedbackGenerator? = nil
    var impactGenerator: UIImpactFeedbackGenerator? = nil
    
    init(enabled: Bool) {
        
        self.isEnabled = enabled
    }
        
    func warmup() {
        if !self.isEnabled {
            return
        }
        
        self.selectGenerator = UISelectionFeedbackGenerator()
        self.impactGenerator = UIImpactFeedbackGenerator()
        
        self.selectGenerator?.prepare()
        self.impactGenerator?.prepare()
    }
    
    func shutDown() {
        self.impactGenerator = nil
        self.selectGenerator = nil
    }
    
    func impact() {
        self.impactGenerator?.impactOccurred()
    }
    
    func select() {
        self.selectGenerator?.selectionChanged()
    }
    
    func enable() {
        self.isEnabled = true
    }
    
    func disable() {
        self.isEnabled = false
    }
}
