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
        
        let fieldSize = 4
        let initialRandomElementsCount = 4
        let initialBlockedCellsCount = 2
        
        self.gameModel = GameModel(
            scene: self,
            view: self.view!,
            fieldSize: fieldSize,
            merging: PowerOfTwoMergingStrategy())
        self.gameModel?.setupCleanGameField(scene: self)
        
        assert(self.gameModel?.fieldWidth == self.gameModel?.fieldHeight, "Only square fields are supported currently")
        
        //DebugPaletteCMD(self.gameModel!).run()
        
        for _ in 0 ..< initialRandomElementsCount {
          
            AddRandomCellCMD(self.gameModel!).runWithDelay(delay: Double.random)
        }
        
        for _ in 0 ..< initialBlockedCellsCount {
            
            BlockRandomCellCMD(self.gameModel!).run()
        }
    }
    
    override func didMove(to view: SKView) {
        self.setUpScene()
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
