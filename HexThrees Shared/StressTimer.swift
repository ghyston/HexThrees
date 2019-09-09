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
    func startNew(timer: Timer, cell: BgCell)
    func getCell() -> BgCell?
}

class TimerModel : ITimerModel {
    
    private var enabled: Bool = false
    private var stressTimer : Timer? //when this timer is fired, new cell appeared on field
    private var cell: BgCell?
    
    
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
        self.cell = nil
    }
    
    //@todo: clear afterwards
    func getCell() -> BgCell? {
        return cell
    }
    
    func startNew(timer: Timer, cell: BgCell) {
        stop()
        stressTimer = timer
        self.cell = cell
    }
    
}
