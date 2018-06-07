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
        scene.scaleMode = .resizeFill
        
        return scene
    }
    
    func setUpScene() {
        
        self.gameModel = GameModel(scene: self, view: self.view!, fieldSize: 4, merging: FibonacciMergingStrategy())
        self.gameModel?.setupCleanGameField(scene: self)
        
        assert(self.gameModel?.fieldWidth == self.gameModel?.fieldHeight, "Only square fields are supported currently")
        
        let initialRandomElementsCount = 4
        
        for _ in 0 ..< initialRandomElementsCount {
          AddRandomCellCMD(self.gameModel!).runWithDelay(delay: Double.random)
        }
    }
    
    override func didMove(to view: SKView) {
        self.setUpScene()
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
