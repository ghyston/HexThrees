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
    var blockedStaticShader : SKShader { get set }
    var blockingAnimatedShader : AnimatedShaderNode { get set }
    var circleTimerAnimatedShader : AnimatedShaderNode { get set }
    var playback : IPlayback? { get set }
    var shape : SKShapeNode? { get set }
    
    var normalBgColor: vector_float3 { get set }
    var blockedBgColor: vector_float3 { get set }
    var blockLinesColor: vector_float3 { get set }
    
    func updateAnimation(_ delta: TimeInterval)
    func loadShader(shape: SKShapeNode, palette: IPaletteManager)
    func removeShader()
    func block()
    func unblock()
}

extension BlockableNode where Self : SKNode {
    
    //@todo: when we change palette, all shaders should be reloaded or color changed
    func loadShader(shape: SKShapeNode, palette: IPaletteManager) {
        self.shape = shape
        self.blockedStaticShader = SKShader.init(fileNamed: "blockStatic2")
        self.blockingAnimatedShader = AnimatedShaderNode.init(fileNamed: "blockAnimated2")
        self.circleTimerAnimatedShader =
            AnimatedShaderNode.init(fileNamed: "circleTimer")
        
        self.normalBgColor = palette.cellBgColor().toVector()
        self.blockedBgColor = palette.cellBlockedBgColor().toVector()
        self.blockLinesColor = palette.cellBlockingLinesColor().toVector()
        
        circleTimerAnimatedShader.addUniform(
            name: "uBgColor",
            value: self.normalBgColor)
            
        circleTimerAnimatedShader.addUniform(
            name: "uBlockedColor",
            value: self.blockedBgColor)
        
        blockingAnimatedShader.addUniform(
            name: "uBgColor",
            value: self.normalBgColor)
        
        blockingAnimatedShader.addUniform(
            name: "uBlockedColor",
            value: self.blockedBgColor)
        
        blockingAnimatedShader.addUniform(
            name: "uBlockedLineColor",
            value: self.blockLinesColor)
        
        blockedStaticShader.addUniform(
            name: "uBlockedColor",
            value: self.blockedBgColor)
        
        blockedStaticShader.addUniform(
            name: "uBlockedLineColor",
            value: self.blockLinesColor)
    }
    
    func playCircleAnimation() {
        self.removeRollbackDelayedAction()
        self.playback = Playback()
        //@todo: use 2PI, find constant
        self.playback?.setRange(from: 0, to: 6.28)
        self.playback!.start(
            duration: GameConstants.StressTimerInterval,
            reversed: false,
            repeated: false,
            onFinish: self.removeShaderWithDelay)
        self.shape?.fillShader = self.circleTimerAnimatedShader
    }
    
    func playRollbackCircleAnimation() {
        self.playback?.rollback(
            duration: GameConstants.StressTimerRollbackInterval,
            onFinish: self.removeShaderWithDelay)
    }
    
    func updateAnimation(_ delta: TimeInterval) {
        if let playbackValue = self.playback?.update(delta: delta) {
            if let shader = self.shape?.fillShader as? AnimatedShaderNode {
                shader.update(playbackValue)
            }
        }
    }
    
    func block() {
        self.removeRollbackDelayedAction()
        
        self.playback = Playback()
        self.playback!.start(
            duration: GameConstants.BlockAnimationDuration,
            reversed: false,
            repeated: false,
            onFinish: self.setStaticBlockShader)
        self.shape?.fillShader = self.blockingAnimatedShader
        
        self.isBlocked = true
    }
    
    func unblock() {
        self.playback = Playback()
        self.playback!.start(
            duration: GameConstants.BlockAnimationDuration,
            reversed: true,
            repeated: false,
            onFinish: self.removeShader)
        self.shape?.fillShader = self.blockingAnimatedShader
        
        self.isBlocked = false
    }
    
    // After stress timer do not remove shader immidiately, wait until new cell is apeared.
    private func removeShaderWithDelay() {
        let delayHide = SKAction.wait(forDuration: GameConstants.CellAppearAnimationDuration)
        let removeShader = SKAction.perform(#selector(BgCell.removeShader), onTarget: self)
        self.run(SKAction.sequence([delayHide, removeShader]), withKey: RollbackActionKey())
    }
    
    private func setStaticBlockShader() {
        self.shape?.fillShader = self.blockedStaticShader
        self.playback = nil
    }
    
    // @todo: any way to declare it in one line?
    private func removeRollbackDelayedAction() {
        self.removeAction(forKey: RollbackActionKey())
    }
    
    // @todo: any way to declare it in one line?
    private func RollbackActionKey() -> String {
        return "rollback_action"
    }
}
