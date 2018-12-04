//
//  GameCell.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 26.04.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit



class GameCell : SKNode, HexNode, LabeledNode {
    
    var hexShape : SKShapeNode
    var label : SKLabelNode
    
    var value: Int
    var newParent : BgCell?
    //#todo: move pal to HexCell? 
    let pal : IPaletteManager = ContainerConfig.instance.resolve()
    
    init(model: GameModel, val: Int) {
        
        self.value = val
        let strategyValue = model.strategy.value(index: self.value)
        
        // this is just to put placeholders
        hexShape = SKShapeNode()
        label = SKLabelNode()
        
        super.init()
        
        addShape(model: model)
        addLabel(text: "\(strategyValue)")
        
        updateColor()
        
        //@todo: do I need to remove observer in destructor?
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onColorChange),
            name: .switchPalette,
            object: nil)
    }
    
    @objc func onColorChange(notification: Notification) {
        updateColor()
    }
    
    func updateColor() {
        
        updateColor(fontColor: .white)
        updateColor(fillColor: pal.color(value: value), strokeColor: .white)
    }
    
    func playAppearAnimation() {
        self.setScale(0.01)
        self.run(SKAction.scale(to: 1.0, duration: 0.5))
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
        moveAnimation.timingMode = SKActionTimingMode.easeInEaseOut
        self.run(moveAnimation)
    }
    
    func removeFromParentWithDelay(delay: Double) {
        let delay = SKAction.wait(forDuration: delay)
        let delete = SKAction.perform(#selector(GameCell.removeFromParent), onTarget: self)
        self.run(SKAction.sequence([delay, delete]))
    }
    
    func updateValue(value: Int, strategy: MergingStrategy) {
        self.value = value
        let strategyValue = strategy.value(index: self.value)
        self.updateText(text: "\(strategyValue)")
        self.playUpdateAnimation()
        updateColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}