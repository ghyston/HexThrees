//
//  GameViewController.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 10.04.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameVC: UIViewController {

    var gameModel : GameModel?
    
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
        
        ContainerConfig.instance.Register(self.gameModel as! GameModel)
        
        let recognizer = HexSwipeGestureRecogniser(
            target: self,
            action:#selector(handleSwipe(recognizer:)))
        recognizer.delegate = self
        self.view.addGestureRecognizer(recognizer)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onGameReset),
            name: .resetGame,
            object: nil)
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc func onGameReset(notification: Notification) {
        //@todo
        print("onGameReset")
    }
}

extension GameVC: UIGestureRecognizerDelegate {
    
    @objc func handleSwipe(recognizer: HexSwipeGestureRecogniser) {
        
        DoSwipeCMD(self.gameModel!).run(direction: recognizer.direction)
    }
    
    // https://stackoverflow.com/questions/4825199/gesture-recognizer-and-button-actions
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view is UIButton) {
            return false
        }
        return true
    }
}
