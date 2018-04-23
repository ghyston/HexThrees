//
//  GameScene.swift
//  HexThrees Shared
//
//  Created by Ilja Stepanow on 10.04.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    
    //fileprivate var label : SKLabelNode?
    //fileprivate var spinnyNode : SKShapeNode?
    var hexCalculator : HexCalculator?
    var hexes : [HexCell] = [HexCell]()
    
    class func newGameScene() -> GameScene {
        // Load 'GameScene.sks' as an SKScene.
        guard let scene = SKScene(fileNamed: "GameScene") as? GameScene else {
            print("Failed to load GameScene.sks")
            abort()
        }
        
        // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFill
        
        return scene
    }
    
    func setUpScene() {
        
        let width = 4
        let height = 4
        let emptyHexSprite = SKSpriteNode.init(imageNamed: "hex")
        
        hexCalculator = HexCalculator(
            width : width,
            height : height,
            gap: 5.0,
            cellSize: emptyHexSprite.size)
        
        for i1 in -2 ... 2 {
            for i2 in -2 ... 2 {
                let hexCell = HexCell(text: "\(i1, i2)")
                self.addChild(hexCell)
                hexCell.position = hexCalculator!.ToScreenCoord(AxialCoord(i1, i2))
                self.hexes.append(hexCell)
            }
        }
        
    }
    
    #if os(watchOS)
    override func sceneDidLoad() {
        self.setUpScene()
    }
    #else
    override func didMove(to view: SKView) {
        self.setUpScene()
    }
    #endif

    /*func makeSpinny(at pos: CGPoint, color: SKColor) {
        if let spinny = self.spinnyNode?.copy() as! SKShapeNode? {
            spinny.position = pos
            spinny.strokeColor = color
            self.addChild(spinny)
        }
    }*/
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

#if os(iOS) || os(tvOS)
// Touch-based event handling
extension GameScene {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /*if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches {
            self.makeSpinny(at: t.location(in: self), color: SKColor.green)
        }*/
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        /*for t in touches {
            self.makeSpinny(at: t.location(in: self), color: SKColor.blue)
        }*/
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        /*for t in touches {
            self.makeSpinny(at: t.location(in: self), color: SKColor.red)
        }*/
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        /*for t in touches {
            self.makeSpinny(at: t.location(in: self), color: SKColor.red)
        }*/
    }
    
   
}
#endif

#if os(OSX)
// Mouse-based event handling
extension GameScene {

    override func mouseDown(with event: NSEvent) {
        /*if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        self.makeSpinny(at: event.location(in: self), color: SKColor.green)*/
    }
    
    override func mouseDragged(with event: NSEvent) {
        //self.makeSpinny(at: event.location(in: self), color: SKColor.blue)
    }
    
    override func mouseUp(with event: NSEvent) {
        //self.makeSpinny(at: event.location(in: self), color: SKColor.red)
    }

}
#endif

