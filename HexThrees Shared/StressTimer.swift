//
//  StressTimer.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 07.06.19.
//  Copyright © 2019 Ilja Stepanow. All rights reserved.
//

import Foundation

protocol ITimerModel {
    
    func enable()
    func disable()
    func isEnabled() -> Bool //@todo: this functionality better somehow move inside timer
    func stop()
    func startNew(timer: Timer)
}

class TimerModel : ITimerModel {
    
    private var enabled: Bool = false
    private var stressTimer : Timer? //when this timer is fired, new cell appeared on field
    
    func enable() {
        enabled = true
    }
    
    func disable() {
        enabled = false
        stop()
    }
    
    func isEnabled() -> Bool {
        return enabled
    }
    
    func stop() {
        stressTimer?.invalidate()
    }
    
    func startNew(timer: Timer) {
        
        
        
        stop()
        stressTimer = timer
    }
    
}
