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
        
        scene.gameModel = GameModel()
        
        return scene
    }
    
    func setUpScene() {
        
        //let emptyHexSprite = SKSpriteNode.init(imageNamed: "hex")
        
        TextureGenerator.generate(view: self.view!, hexCount: self.gameModel?.fieldWidth ?? 0)
        
        assert((TextureGenerator.grayHexTexture != nil), "Gray texture not generated")
        
        
        self.gameModel?.setupCleanGameField(
            cellSize: TextureGenerator.grayHexTexture!.size(),
            scene: self)
        
        assert(self.gameModel?.fieldWidth == self.gameModel?.fieldHeight, "Only square fields are supported currently")
        
        let initialRandomElementsCount = 4
        
        for _ in 0 ..< initialRandomElementsCount {
          AddRandomCellCMD(self.gameModel!).run()
        }
        
        let xScale = self.scene?.xScale ?? 0.0
        let yScale = self.scene?.yScale ?? 0.0
        let width = self.scene?.view?.frame.width ?? 10
        
        let circle = SKShapeNode.init(circleOfRadius: width * xScale * 0.5)
        circle.strokeColor = .red
        addChild(circle)
        
        /*let firstElement = GameCell(val: 1)
        let secondElement = GameCell(val: 1)
        
        self.gameModel?.bgHexes[8].addGameCell(cell: firstElement)
        self.gameModel?.bgHexes[16].addGameCell(cell: secondElement)*/
        
        
        /*for i8 in 0 ... 16 {
            let firstElement = GameCell(val: i8)
            self.bgHexes[i8].addGameCell(cell: firstElement)
        }*/
    }
    
    override func didMove(to view: SKView) {
        self.setUpScene()
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
