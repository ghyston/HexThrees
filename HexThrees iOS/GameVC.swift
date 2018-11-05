
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

    @IBOutlet weak var scoreLabel: UILabel!
    
    var gameModel : GameModel?
    var scene : GameScene?
    var defaultGameParams: GameParams?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPalette()
        
        self.scene = GameScene.newGameScene()

        // Present the scene
        let skView = self.view as! SKView
        skView.presentScene(self.scene)
        
        skView.ignoresSiblingOrder = true
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        self.defaultGameParams = GameParams(
            fieldSize: 4,
            randomElementsCount: 4,
            blockedCellsCount: 2,
            strategy: .Hybrid,
            palette: .Dark)
        
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
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onScoreUpdate),
            name: .updateScore,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onGameEnd),
            name: .gameOver,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onColorChange),
            name: .switchPalette,
            object: nil)
        
        startGame()
        
        if FileHelper.SaveFileExist() {
            LoadGameCMD(self.gameModel!).run()
        } else {
            AddRandomElementsCMD(self.gameModel!).run(
                cells: self.defaultGameParams!.randomElementsCount,
                blocked: self.defaultGameParams!.blockedCellsCount)
        }
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
    
    private func loadPalette() {
        
        let pal : IPaletteManager = PaletteManager()
        ContainerConfig.instance.register(pal)
    }
    
    private func startGame() {
        
        let cmd = StartGameCMD(
            scene: self.scene!,
            view: self.view as! SKView,
            params: self.defaultGameParams!)
        cmd.run()
        
        self.gameModel = cmd.gameModel
        //DebugPaletteCMD(self.gameModel!).run()
        ContainerConfig.instance.register(self.gameModel!)
        setSceneColor()
    }
    
    @objc func onGameReset(notification: Notification) {
        
        CleanGameCMD(self.gameModel!).run()
        startGame()
        AddRandomElementsCMD(self.gameModel!).run(
            cells: self.defaultGameParams!.randomElementsCount,
            blocked: self.defaultGameParams!.blockedCellsCount)
    }
    
    @objc func onScoreUpdate(notification: Notification) {
        
        scoreLabel.text = "\(self.gameModel!.score)"
    }
    
    @objc func onGameEnd(notification: Notification) {
        
        showEndGameVC()
    }
    
    @objc func onColorChange(notification: Notification) {
        
        setSceneColor()
    }
    
    private func setSceneColor() {
        
        let pal : IPaletteManager = ContainerConfig.instance.resolve()
        self.scene?.backgroundColor = pal.sceneBgColor()
        
        if let fieldOutine = self.scene?.childNode(withName: FieldOutline.defaultNodeName) as? FieldOutline {
            fieldOutine.updateColor(color: pal.fieldOutlineColor())
        }
    }
    
    private func showEndGameVC() {
        let storyboardName = "Main"
        let endGameVcName = "GameOverVC"
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: endGameVcName)
        
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func onLoad(_ sender: Any) {
        
        CleanGameCMD(self.gameModel!).run()
        startGame()
        LoadGameCMD(self.gameModel!).run()
    }
    
    @IBAction func onSave(_ sender: Any) {
        
        SaveGameCMD(self.gameModel!).run()
    }
    
    @IBAction func onEndGame(_ sender: Any) {
        
        showEndGameVC()
    }
    
    @IBAction func onColorChangeClick(_ sender: Any) {
        
        SwitchPaletteCMD(self.gameModel!).run()
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
