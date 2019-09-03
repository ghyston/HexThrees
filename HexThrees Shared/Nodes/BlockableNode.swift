//
//  BlockableNode.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 04.12.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

protocol BlockableNode : class {
    
    var isBlocked: Bool { get set }
    var blockShader : SKShader { get set }
    var blockedAnimationShader : AnimatedShaderNode { get set }
    var playback : IPlayback? { get set }
    var shape : SKShapeNode? { get set }
    
    func updateAnimation(_ delta: TimeInterval)
    func loadShader(shape: SKShapeNode, palette: IPaletteManager)
    func block()
    func unblock()
}

extension BlockableNode where Self : SKNode {
    
    //@todo: when we change palette, all shaders should be reloaded or color changed
    func loadShader(shape: SKShapeNode, palette: IPaletteManager) {
        self.shape = shape
        self.blockShader = SKShader.init(fileNamed: "gridDervative")
        self.blockedAnimationShader =
            AnimatedShaderNode.init(fileNamed: "blockTimer")
        
        let bgColor = palette.cellBgColor().toVector()
        let blockedColor = palette.cellBlockedBgColor().toVector()
        
        blockedAnimationShader.addUniform(
            name: "uBgColor",
            value: bgColor)
            
        blockedAnimationShader.addUniform(
            name: "uBlockedColor",
            value: blockedColor)
    }
    
    func animatePrepareToBlock() {
        self.playback = Playback()
        //@todo: use 2PI, find constant
        self.playback?.setRange(from: 0, to: 6.28)
        self.playback!.start(
            duration: GameConstants.StressTimerInterval,
            reversed: false,
            repeated: false)
        self.shape?.fillShader = self.blockedAnimationShader
    }
    
    //@todo: awful names
    func animateReversePrepareToBlock() {
        //@todo
    }
    
    func updateAnimation(_ delta: TimeInterval) {
        if let playbackValue = self.playback?.update(delta: delta) {
            self.blockedAnimationShader.update(playbackValue)
        }
    }
    
    func block() {
        self.shape?.fillShader = blockShader
        self.isBlocked = true
    }
    
    func unblock() {
        self.shape?.fillShader = nil
        self.isBlocked = false
    }
}
