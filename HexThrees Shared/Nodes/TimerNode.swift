//
//  TimerNode.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 09.05.19.
//  Copyright © 2019 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

class TimerNode : SKNode {
    
    private enum Status {
        case hidden
        case regular
        case rollback
    }
    
    private var currentColorValue: Int = 0
    private var startedTime = TimeInterval()
    private let bar : SKShapeNode
    private let barSizeRatio : Float
    private var shader : SKShader
    private var leftToRight: Bool = true
    private var status: Status = .regular
    
    init(period: TimeInterval, width: CGFloat) {
        
        let height : CGFloat = 20
        let offset : CGFloat = 20
        let hW = width / 2
        let hH = height / 2
        barSizeRatio = Float(height / width)
        
        let path = CGMutablePath.init()
        
        path.move(to: CGPoint(x: -hW + offset, y: hH))
        path.addLine(to: CGPoint(x: hW - offset, y: hH))
        
        bar = SKShapeNode.init(path: path)
        bar.lineWidth = height
        
        bar.lineCap = .round
        self.shader = SKShader.init(fileNamed: "timer.fsh")
        
        shader.addUniform(SKUniform(name: "uPos", float: 0.3))
        shader.addUniform(SKUniform(name: "uClrLeft", vectorFloat3: vector_float3(0.1,0.1,0.1)))
        shader.addUniform(SKUniform(name: "uClrRight", vectorFloat3: vector_float3(0.1,0.1,0.1)))
        
        bar.strokeShader = shader
        
        super.init()
        addChild(bar)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(startOver),
            name: .startTimer,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(rollback),
            name: .rollbackTimer,
            object: nil)
    }
    
    @objc private func rollback() {
        
        //print("rollback from state \(status)")
        
        if status != .regular {
            return
        }
        
        let alreadyPassed = normalize(
            value: startedTime,
            duration: GameConstants.StressTimerInterval)
        let immitatePast = Double(1.0 - alreadyPassed) * GameConstants.StressTimerRollbackInterval
        
        startedTime = immitatePast
        status = .rollback
        leftToRight = !leftToRight
    }
    
    private func normalize(value: TimeInterval, duration: TimeInterval) -> Float {
        
        return Float(min(value / duration, 1.0))
    }
    
    // Scale value that is [0.0, 1.0] to [0, by] and switch scale center to 0.5
    // So, in example, 0.3 scaled to 2.0 would be 0.6 in range [-0.5, 1.5] => 0.1
    private func scale(value: Float, by: Float) -> Float {
        return value * by - (by - 1.0) * 0.5;
        //posPercent * (1.0 + barSizeRatio) - barSizeRatio * 0.5
    }
    
    @objc private func startOver() {
        
        print("startOver from state \(status)")
        
        //@todo: fix exception here!!
        if (status == .rollback) {
            currentColorValue -= 1
        }
        
        status = .regular
        startedTime = TimeInterval()
        
        guard let palette : IPaletteManager = ContainerConfig.instance.tryResolve() else {
            return
        }
        
        let clrCurr = palette.color(value: currentColorValue).toVector()
        currentColorValue += 1
        let clrNext = palette.color(value: currentColorValue).toVector()
        
        let uClrLeft = self.shader.uniformNamed("uClrLeft")
        uClrLeft?.vectorFloat3Value = !leftToRight ? clrCurr : clrNext
        
        let uClrRight = self.shader.uniformNamed("uClrRight")
        uClrRight?.vectorFloat3Value = !leftToRight ? clrNext : clrCurr
        
        // 8 is min posible strategy max defined value
        // (better to call gameModel.fieldSize ^ 2)
        if currentColorValue > 8 {
            currentColorValue = 0
        }
        
        leftToRight = !leftToRight
    }
    
    func update(_ delta: TimeInterval) {
        
        startedTime += delta
        let durationInterval = status == .regular ?
            GameConstants.StressTimerInterval :
            GameConstants.StressTimerRollbackInterval
        
        // normalize time
        let percent = normalize(
            value: startedTime,
            duration: durationInterval)
        // we need this to move from right to left
        let posPercent = leftToRight ? percent : (1.0 - percent)
        
        // this calculations cover extend percentage to cover corners of timer bar
        let floatUPos = scale(
            value: posPercent,
            by: (1.0 + barSizeRatio))
        //print("pos: \(floatUPos) status: \(status)")
        
        let uPos = self.shader.uniformNamed("uPos")
        uPos?.floatValue = floatUPos
    }
    
    //@todo: why do we need all these coders?
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
