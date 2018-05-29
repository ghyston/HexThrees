//
//  GameScene.swift
//  HexThrees Shared
//
//  Created by Ilja Stepanow on 10.04.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var gameModel : GameModel?
    
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
        
        self.gameModel = GameModel()
        
        self.gameModel?.setupCleanGameField(
            cellSize: emptyHexSprite.size,
            scene: self)
       
        
        let initialRandomElementsCount = 4
        
        for _ in 0 ..< initialRandomElementsCount {
          AddRandomCellCMD(self.gameModel!).run()
        }
        
        /*let firstElement = GameCell(val: 1)
        let secondElement = GameCell(val: 1)
        
        self.gameModel?.bgHexes[8].addGameCell(cell: firstElement)
        self.gameModel?.bgHexes[16].addGameCell(cell: secondElement)*/
        
        
        /*for i8 in 0 ... 16 {
            let firstElement = GameCell(val: i8)
            self.bgHexes[i8].addGameCell(cell: firstElement)
        }*/
    }
    
    func touch(coord: CGPoint) {
        
        if self.gameModel?.swipeStatus.inProgress ?? true {
            return
        }
        
        self.gameModel?.swipeStatus.inProgress = true
        
        if coord.x < -500 {
            MoveLeftCMD(self.gameModel!).run()
        }
        else if coord.x > 500 {
            MoveRightCMD(self.gameModel!).run()
        } else if coord.x < 0 && coord.y < 0 {
            MoveXDownCMD(self.gameModel!).run()
        }
        else if coord.x < 0 && coord.y > 0 {
            MoveYUpCMD(self.gameModel!).run()
        }
        else if coord.x > 0 && coord.y < 0 {
            MoveYDownCMD(self.gameModel!).run()
        }
        else if coord.x > 0 && coord.y > 0 {
            MoveXUpCMD(self.gameModel!).run()
        }
        
        FinishSwipeCMD(self.gameModel!).runWithDelay(delay: gameModel?.swipeStatus.delay ?? 0.0)
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
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

#if os(iOS) || os(tvOS)
// Touch-based event handling
extension GameScene {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //@todo: handle multitouch
        guard let firstTouch = touches.first else {
            return
        }
        
        touch(coord: firstTouch.location(in: self))
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
   
}
#endif

#if os(OSX)
// Mouse-based event handling
extension GameScene {

    override func mouseDown(with event: NSEvent) {
        
        touch(coord: event.location(in: self))
    }
    
    override func mouseDragged(with event: NSEvent) {
        
    }
    
    override func mouseUp(with event: NSEvent) {
        
    }

}
#endif

