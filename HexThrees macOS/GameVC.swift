//
//  GameViewController.swift
//  HexThrees macOS
//
//  Created by Ilja Stepanow on 10.04.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit

class GameVC: NSViewController {

    var gameModel: GameModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = GameScene.newGameScene()
        
        // Present the scene
        let skView = self.view as! SKView
        skView.presentScene(scene)
        
        skView.ignoresSiblingOrder = true
        
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        let startParams = GameParams(
            fieldSize: 4,
            randomElementsCount: 4,
            blockedCellsCount: 2,
            strategy: PowerOfTwoMergingStrategy())
        
        let cmd = StartGameCMD(
            scene: scene,
            view: skView,
            params: startParams)
        cmd.run()
        self.gameModel = cmd.gameModel
    }

}

