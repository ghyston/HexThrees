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
    private let bar : SKShapeNode
    private var shader : AnimatedShaderNode
    private var leftToRight: Bool = true
    private var status: Status = .regular
    
    init(period: TimeInterval, width: CGFloat) {
        
        let height : CGFloat = 20
        let offset : CGFloat = 20
        let hW = width / 2
        let hH = height / 2
        let barSizeRatio = Float(height / width)
        
        let path = CGMutablePath.init()
        
        path.move(to: CGPoint(x: -hW + offset, y: hH))
        path.addLine(to: CGPoint(x: hW - offset, y: hH))
        
        bar = SKShapeNode.init(path: path)
        bar.lineWidth = height
        
        bar.lineCap = .round
        self.shader = AnimatedShaderNode.init(fileNamed: "timer")
        self.shader.setScale(1.0 + barSizeRatio)
        
        shader.addUniform(
            name: "uClrLeft",
            value: vector_float3(0.1,0.1,0.1))
        shader.addUniform(
            name: "uClrRight",
            value: vector_float3(0.1,0.1,0.1))
        
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
        
        print("rollback from state \(status)")
        
        self.shader.reverse()
        if status != .regular {
            return
        }
        
        status = .rollback
        leftToRight = !leftToRight
        
        self.shader.rollback(duration: GameConstants.StressTimerRollbackInterval)
    }
    
    @objc private func startOver() {
        
        print("startOver from state \(status)")
        
        //@todo: make cyclic int, that will repeat on increase?
        if (status == .rollback) {
            currentColorValue -= 1
            if currentColorValue < 0 {
                currentColorValue = 8
            }
        }
        
        status = .regular
        
        guard let palette : IPaletteManager = ContainerConfig.instance.tryResolve() else {
            return
        }
        
        let clrCurr = palette.color(value: currentColorValue).toVector()
        currentColorValue += 1
        let clrNext = palette.color(value: currentColorValue).toVector()
        
        self.shader.updateUniform(
            name: "uClrLeft",
            value: leftToRight ? clrCurr : clrNext)
        
        self.shader.updateUniform(
            name: "uClrRight",
            value: leftToRight ? clrNext : clrCurr)
        
        
        // 8 is min posible strategy max defined value
        // (better to call gameModel.fieldSize ^ 2)
        if currentColorValue > 8 {
            print("startOver reset currentColorValue")
            currentColorValue = 0
        }
        
        leftToRight = !leftToRight
        self.shader.reverse()
        
        self.shader.start(duration: GameConstants.StressTimerInterval)
    }
    
    func update(_ delta: TimeInterval) {
        
        self.shader.update(delta)
    }
    
    //@todo: why do we need all these coders?
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}