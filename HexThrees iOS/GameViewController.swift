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

class GameViewController: UIViewController {

    var gameModel : GameModel? //@todo: use singleton for this
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = GameScene.newGameScene()
        self.gameModel = scene.gameModel //@todo: use singleton/container for this

        // Present the scene
        let skView = self.view as! SKView
        skView.presentScene(scene)
        
        skView.ignoresSiblingOrder = true
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        let recognizer = HexSwipeGestureRecogniser(
            target: self,
            action:#selector(handleSwipe(recognizer:)))
        recognizer.delegate = self as! UIGestureRecognizerDelegate
        self.view.addGestureRecognizer(recognizer)
        
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
}

extension GameViewController: UIGestureRecognizerDelegate {
    
    @objc func handleSwipe(recognizer: HexSwipeGestureRecogniser) {
        
        //@todo: make a command to swipe?
        
        //@todo: make a queue of swipes
        if self.gameModel?.swipeStatus.inProgress ?? true {
            return
        }
        
        self.gameModel?.swipeStatus.inProgress = true
        
        switch recognizer.direction {
        case .Left:
            MoveLeftCMD(self.gameModel!).run()
        case .Right:
            MoveRightCMD(self.gameModel!).run()
        case .XUp:
            MoveXUpCMD(self.gameModel!).run()
        case .YUp:
            MoveYUpCMD(self.gameModel!).run()
        case .XDown:
            MoveXDownCMD(self.gameModel!).run()
        case .YDown:
            MoveYDownCMD(self.gameModel!).run()
        case .Unknown:
            return
        }
        
        FinishSwipeCMD(self.gameModel!).runWithDelay(delay: gameModel?.swipeStatus.delay ?? 0.0)
    }
}
