//
//  AnimatedShaderNode.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 15.06.19.
//  Copyright © 2019 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

extension SKShader {
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
}

class AnimatedShader: SKShader {
    
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

    func update(_ floatUPos: Float) {
        let uPos = uniformNamed("uPos")
        uPos?.floatValue = floatUPos
    }
    
    func update(_ doubleUPos: Double) {
        update(Float(doubleUPos))
    }
}
