//
//  HexCell.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 10.04.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

class HexCell : SKNode {
    
    var k : Int = 0 {
        didSet {
            RecalcDecartValues()
        }
    }
    
    var h : Int = 0 {
        didSet {
            RecalcDecartValues()
        }
    }
    
    var l : Int = 0 {
        didSet {
            RecalcDecartValues()
        }
    }
    
    private var x : Float = 0.0
    private var y : Float = 0.0
    
    private let spriteW : CGFloat
    private let spriteH : CGFloat
    
    var sprite : SKSpriteNode
    
    let angle : Float = 0.7 //@todo: calculate properly
    
    private func RecalcDecartValues() {
        //@todo: update calculations
        x = Float(k + h) * 0.6
        y = Float(k - h) * 0.8211
        
        self.sprite.position = CGPoint(
            x: CGFloat(x) * spriteW,
            y: CGFloat(y) * spriteH)
        print("coords: \(self.sprite.position)")
    }
    
    func Verify() -> Bool {
        return l == k + h //@todo: not directly
    }
    
    override init() {
        
        self.sprite = SKSpriteNode.init(imageNamed: "hex")
        self.spriteW = self.sprite.size.width
        self.spriteH = self.sprite.size.height
        
        super.init()
        
        self.addChild(self.sprite)
    }
    
    convenience init(k: Int, h: Int, l: Int) {
        
        self.init()
        
        self.k = k
        self.h = h
        self.l = l
        //Verify() //@todo: throw exception
        RecalcDecartValues()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
