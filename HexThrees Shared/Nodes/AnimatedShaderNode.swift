//
//  AnimatedShaderNode.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 15.06.19.
//  Copyright © 2019 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

protocol IAnimatedShaderNode : class {
    
    var shader : SKShader { get set } //@todo: set should be private
    
    func setup(shaderName: String)
    
    func addUniform(name: String, value: Float)
    func addUniform(name: String, value: vector_float3)
    
    func update(_ delta: TimeInterval)
    func start(duration: TimeInterval)
}

class AnimatedShaderNode: SKShader {
    
    private var started = TimeInterval()
    private var duration = TimeInterval()
    private var reversed = false
    private var scale : Float = 1.0
    
    convenience init(fileNamed: String) {
    
        if let fileURL = Bundle.main.url(forResource: fileNamed, withExtension: "fsh") {
            do {
                let shaderSource = try String(contentsOf: fileURL, encoding: .utf8)
                self.init(
                    source: shaderSource,
                    uniforms: [SKUniform(name: "uPos", float: 0.0)])
                return
            } catch {
                print("load shader file failed: \(error)")  // @todo: proper error handling
            }
        }
        else {
            print("file \(fileNamed) not found")  // @todo: proper error handling
        }
        
        self.init() //@todo: this is for error case. Control flow in this function needs to be reviewed
    }
    
    func setScale(_ scale: Float) {
        self.scale = scale
    }
    
    func addUniform(name: String, value: Float) {
        addUniform(SKUniform(name: name, float: value))
    }
    
    func addUniform(name: String, value: vector_float3) {
        addUniform(SKUniform(name: name, vectorFloat3: value))
    }
    
    func updateUniform(name: String, value: Float) {
        uniformNamed(name)?.floatValue = value
    }
    
    func updateUniform(name: String, value: vector_float3) {
        uniformNamed(name)?.vectorFloat3Value = value
    }
    
    func start(duration: TimeInterval, reversed: Bool? = nil) {
        self.started = TimeInterval()
        self.duration = duration
        self.reversed = reversed ?? self.reversed
    }
    
    func rollback(duration: TimeInterval) {
        
        let percent = normalize(
            value: self.started,
            duration: self.duration)
        let newPercent = 1.0 - percent
        
        self.started = Double(newPercent) * duration
        self.duration = duration
        //self.reversed.toggle()
    }
    
    func reverse(reversed : Bool? = nil) {
        self.reversed = reversed ?? !self.reversed
    }
    
    func update(_ delta: TimeInterval) {
        self.started += delta
        let percent = normalize(
            value: self.started,
            duration: self.duration)
        let posPercent = reversed ? percent : (1.0 - percent)
        
        let floatUPos = scale(
            value: posPercent,
            by: (self.scale))
        
        let uPos = uniformNamed("uPos")
        uPos?.floatValue = floatUPos
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
