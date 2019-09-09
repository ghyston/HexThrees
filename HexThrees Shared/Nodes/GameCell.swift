//
//  GameCell.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 26.04.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit



class GameCell : SKNode, HexNode, LabeledNode, MotionBlurNode {
    var prevPosition: CGPoint?
    var prevDelta: Double?
    
    var hexShape : SKShapeNode
    var label : SKLabelNode
    
    var effectNode : SKEffectNode
    var blurFilter : CIFilter
    var motionBlurDisabled : Bool
    
    var value: Int
    var newParent : BgCell?
    let pal : IPaletteManager = ContainerConfig.instance.resolve()
    
    init(model: GameModel, val: Int) {
        
        self.value = val
        self.motionBlurDisabled = !model.motionBlurEnabled
        let strategyValue = model.strategy[self.value]
        
        // this is just to put placeholders
        hexShape = model.geometry.createHexCellShape()
        label = SKLabelNode()
        effectNode = SKEffectNode()
        blurFilter = CIFilter()
        prevPosition = CGPoint()
        
        super.init()
        
        addBlur()
        addShape(shape: hexShape)
        addLabel(text: "\(strategyValue)")
        
        updateColor()
        
        //@todo: do I need to remove observer in destructor?
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onColorChange),
            name: .switchPalette,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onMotionBlurSettingsChange),
            name: .switchMotionBlur,
            object: nil)
    }
    
    @objc func onColorChange(notification: Notification) {
        updateColor()
    }
    
    @objc func onMotionBlurSettingsChange(notification: Notification) {
        
        guard let isOn = notification.object as? Bool else {
            return
        }
        
        isOn ? enableBlur() : disableBlur()
    }
    
    func updateColor() {
        
        updateColor(fontColor: .white)
        updateColor(fillColor: pal.color(value: value), strokeColor: .white)
    }
    
    func updateColorForTutorial() {
        
        updateColor(fontColor: .white)
        updateColor(fillColor: pal.cellTutorialColor(), strokeColor: .white)
    }
    
    func playAppearAnimation() {
        self.setScale(0.01)
        self.run(SKAction.scale(to: 1.0, duration: GameConstants.CellAppearAnimationDuration))
    }
    
    func playUpdateAnimation() {
        
        let zoomIn = SKAction.scale(to: 1.5, duration: 0.3)
        zoomIn.timingMode = SKActionTimingMode.easeIn
        let zoomOut = SKAction.scale(to: 1.0, duration: 0.2)
        zoomOut.timingMode = SKActionTimingMode.easeIn
        self.run(SKAction.sequence([zoomIn, zoomOut]))
    }
    
    func playMoveAnimation(diff: CGVector, duration: Double) {
        
        let moveAnimation = SKAction.move(by: diff, duration: duration)
        moveAnimation.timingMode = SKActionTimingMode.easeIn
        self.run(moveAnimation)
        
        //@todo: move this to MotionBlurNode ?
        self.startBlur()
        let delayStopBlur = SKAction.wait(forDuration: duration)
        let delete = SKAction.perform(#selector(GameCell.stopBlurDelayed), onTarget: self)
        self.run(SKAction.sequence([delayStopBlur, delete]))
    }
    
    @objc func stopBlurDelayed() {
        self.stopBlur()
    }
    
    func removeFromParentWithDelay(delay: Double) {
        let delay = SKAction.wait(forDuration: delay)
        let delete = SKAction.perform(#selector(GameCell.removeFromParent), onTarget: self)
        self.run(SKAction.sequence([delay, delete]))
    }
    
    func updateValue(value: Int, strategy: MergingStrategy, animate: Bool = true) {
        self.value = value
        let strategyValue = strategy[self.value]
        self.updateText(text: "\(strategyValue)")
        if animate {
            self.playUpdateAnimation()
        }
        updateColor()
    }
    
    //@todo: this is a big dirty hack
    override func addChild(_ node: SKNode) {
        
        if effectNode.parent != nil {
            effectNode.addChild(node)
        } else {
            super.addChild(node)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
