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
	func isEnabled() -> Bool // @todo: this functionality better somehow move inside timer
	func stop()
	func fire()
	func startNew(timer: Timer, cell: BgCell)
	func getCell() -> BgCell?
	
	func startDelay(timer: Timer)
	func cancelDelayedStart()
}

class TimerModel: ITimerModel {
	private var enabled: Bool = false
	private var stressTimer: Timer? // when this timer is fired, new cell appeared on field
	private var cell: BgCell?
	
	private var stressTimerCmdDelay: Timer?
	
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
		cell = nil
	}
	
	func fire() {
		stressTimer?.fire()
		stop()
	}
	
	// @todo: clear afterwards
	func getCell() -> BgCell? {
		return cell
	}
	
	func startNew(timer: Timer, cell: BgCell) {
		stop()
		stressTimer = timer
		self.cell = cell
	}
	
	/// MARK: StressTimer delay
	func startDelay(timer: Timer) {
		cancelDelayedStart()
		stressTimerCmdDelay = timer
	}
	
	func cancelDelayedStart() {
		stressTimerCmdDelay?.invalidate()
		stressTimerCmdDelay = nil
	}
}
