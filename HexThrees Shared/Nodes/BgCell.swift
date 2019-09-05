//
//  BgCell.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 26.04.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

class BgCell: SKNode, HexNode, BlockableNode, BonusableNode {
    
    var playback: IPlayback?
    var hexShape : SKShapeNode
    var isBlocked: Bool = false
    var blockedStaticShader : SKShader //@todo: make it lazy static (to init once per game)
    var circleTimerAnimatedShader : AnimatedShaderNode //@todo: same?
    var blockingAnimatedShader : AnimatedShaderNode
    var shape : SKShapeNode?
    var normalBgColor: vector_float3
    var blockedBgColor: vector_float3
    var blockLinesColor: vector_float3
    
    var gameCell: GameCell?
    var bonus: BonusNode?
    let coord: AxialCoord
    let pal : IPaletteManager = ContainerConfig.instance.resolve()
    
    init(hexShape: SKShapeNode, blocked: Bool, coord: AxialCoord) {
        
        self.isBlocked = blocked
        self.coord = coord
        
        //we need to set them to something in order to call super init
        //@todo: crap, just find a way to refactor this!!
        self.hexShape = SKShapeNode()
        self.blockedStaticShader = SKShader()
        self.circleTimerAnimatedShader = AnimatedShaderNode()
        self.blockingAnimatedShader = AnimatedShaderNode()
        self.normalBgColor = vector_float3()
        self.blockedBgColor = vector_float3()
        self.blockLinesColor = vector_float3()
        
        super.init()
        
        self.addShape(shape: hexShape)
        self.loadShader(
            shape: hexShape,
            palette: pal)
        
        if blocked {
            block()
        }
        
        updateColor(fillColor: pal.cellBgColor(), strokeColor: .white)
        
        //@todo: do I need to remove observer in destructor?
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onColorChange),
            name: .switchPalette,
            object: nil)
    }
    
    @objc func onColorChange(notification: Notification) {
        
        updateColor(fillColor: pal.cellBgColor(), strokeColor: .white)
    }
    
    @objc func addGameCell(cell: GameCell) {
        
        assert(self.gameCell == nil, "BgCell already contain game cell")
        
        self.gameCell = cell
        self.addChild(cell)
        self.gameCell?.zPosition = zPositions.bgCellZ.rawValue
    }
    
    @objc func removeGameCell() {
        self.gameCell?.removeFromParent()
        self.gameCell = nil
    }
    
    
    func destination(to: BgCell) -> CGVector {
        return CGVector(from: position, to: to.position);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
