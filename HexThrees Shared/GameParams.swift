//
//  GameParams.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 25.06.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

struct GameParams {
	let randomElementsCount: Int
	let blockedCellsCount: Int
	let motionBlur: MotionBlurStatus
	let hapticFeedback: HapticFeedbackStatus
	let strategy: MergingStrategyName
	let palette: ColorSchemaType
	let stressTimer: StressTimerStatus
	let useButtons: UseButtonStatus
}
