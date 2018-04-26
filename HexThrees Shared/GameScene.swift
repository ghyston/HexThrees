//
//  GameScene.swift
//  HexThrees Shared
//
//  Created by Ilja Stepanow on 10.04.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var hexCalculator : HexCalculator?
    var bgHexes : [BgCell] = [BgCell]()
    let fieldWidth: Int = 5
    let fieldHeight: Int = 5
    let startOffsetX: Int = -2
    let startOffsetY: Int = -2
    
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
        
        let emptyHexSprite = SKSpriteNode.init(imageNamed: "hex")
        
        hexCalculator = HexCalculator(
            width : fieldWidth,
            height : fieldHeight,
            gap: 5.0,
            cellSize: emptyHexSprite.size)
        
        var i = 0
        for i1 in startOffsetX ... (startOffsetX + fieldWidth - 1) {
            for i2 in startOffsetY ... (startOffsetY + fieldHeight - 1) {
                let hexCell = BgCell(
                    coord: AxialCoord(i1, i2),
                    hexCalc : hexCalculator!)
                self.addChild(hexCell)
                self.bgHexes.append(hexCell)
                i += 1
            }
        }
        
        //addRandomElement()
        //addRandomElement()
        //addRandomElement()
        //addRandomElement()
        
        let firstElement = GameCell(val: 1)
        self.bgHexes[0].addGameCell(cell: firstElement)
        
        let secondElement = GameCell(val: 1)
        self.bgHexes[1].addGameCell(cell: secondElement)
    }
    
    private func addRandomElement() {
        
        var freeCells = Array<BgCell>()
        for i in self.bgHexes {
            if(i.gameCell == nil) {
                freeCells.append(i)
            }
        }
        
        let random = Int(arc4random()) % freeCells.count
        
        let newElement = GameCell(val: 1)
        freeCells[random].addGameCell(cell: newElement)
    }
    
    //@todo: make cmd from it
    private func moveXUp() {
        
        for i2 in 0 ... (fieldHeight - 1) {
            for i1 in 0 ... (fieldWidth - 1) {
             
                let hexCell = self.bgHexes[i2 * fieldWidth + i1]
                guard let gameCell = hexCell.gameCell else {
                    continue
                }
                    
                if(i1 == fieldWidth - 1) {
                    hexCell.removeGameCell()
                    continue
                }
                    
                let newCellRoot = self.bgHexes[i2 * fieldWidth + i1 + 1]
                let coordDiff = CGVector(
                    dx:  newCellRoot.position.x - hexCell.position.x,
                    dy:  newCellRoot.position.y - hexCell.position.y)
                
                gameCell.newParent = newCellRoot
                
                let moveAction = SKAction.move(by: coordDiff, duration: 1.0)
                let resetAction = SKAction.perform(#selector(GameCell.resetCoordinates), onTarget: gameCell)
                let addToNewRootAction = SKAction.perform(#selector(GameCell.switchToNewParent), onTarget: gameCell)
                gameCell.run(SKAction.sequence([moveAction, resetAction, addToNewRootAction]))
                
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
        self.moveXUp()
    }
    
    override func mouseDragged(with event: NSEvent) {
        //self.makeSpinny(at: event.location(in: self), color: SKColor.blue)
    }
    
    override func mouseUp(with event: NSEvent) {
        //self.makeSpinny(at: event.location(in: self), color: SKColor.red)
    }

}
#endif

