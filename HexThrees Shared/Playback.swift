//
//  Playback.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 07.08.19.
//  Copyright © 2019 Ilja Stepanow. All rights reserved.
//

import Foundation

protocol IPlayback {
    
    func setRange(from: Float, to: Float)
    func start(duration: TimeInterval, reversed: Bool?, repeat: Bool?/*, onFinish: ()*/)
    func rollback(duration: TimeInterval/*, onFinish: ()?*/)
    func update(delta: TimeInterval) -> Float
    func reverse(reversed: Bool?)
    //func pause() //@todo
    //func resume() //@todo
}

class Playback : IPlayback {
    
    private var started = TimeInterval()
    private var duration = TimeInterval()
    private var reversed = false
    private var scale : Float = 1.0
    
    func setRange(from: Float, to: Float) {
        scale = (to - from); //@todo: recheck, it __IS__ wrong
    }
    
    func start(duration: TimeInterval, reversed: Bool? = nil, repeat: Bool? = false/*, onFinish: ()*/) {
        
        //@todo: use repeat
        self.started = TimeInterval()
        self.duration = duration
        self.reversed = reversed ?? self.reversed
    }
    
    func rollback(duration: TimeInterval/*, onFinish: ()? = nil*/) {
        let percent = normalize(
            value: self.started,
            duration: self.duration)
        let newPercent = 1.0 - percent
        self.reverse()
        
        self.started = Double(newPercent) * duration
        self.duration = duration
    }
    
    func update(delta: TimeInterval) -> Float {
        self.started += delta
        let percent = normalize(
            value: self.started,
            duration: self.duration)
        let posPercent = reversed ? percent : (1.0 - percent)
        
        return scale(
            value: posPercent,
            by: (self.scale))
    }
    
    func reverse(reversed : Bool? = nil) {
        self.reversed = reversed ?? !self.reversed
    }
    
    // Scale value that is [0.0, 1.0] to [0, by] and switch scale center to 0.5
    // So, in example, 0.3 scaled to 2.0 would be 0.6 in range [-0.5, 1.5] => 0.1
    private func scale(value: Float, by: Float) -> Float {
        return value * by - (by - 1.0) * 0.5;
    }
    
    private func normalize(value: TimeInterval, duration: TimeInterval) -> Float {
        return Float(min(value / duration, 1.0))
    }
}
