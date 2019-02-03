
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
    @IBOutlet weak var scoreMultiplierLabel: UILabel!
    
    var gameModel : GameModel?
    var scene : GameScene?
    var currentGameParams: GameParams?
    
    //@todo: disable haptic and blur models olther than (?) 6s/SE
    let defaultGameParams = GameParams(
        fieldSize: FieldSize.Quaddro,
        randomElementsCount: 4,
        blockedCellsCount: 2,
        motionBlur: MotionBlurStatus.Enabled,
        hapticFeedback: HapticFeedbackStatus.Enabled,
        strategy: .Hybrid,
        palette: .Dark)
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPalette()
        
        self.scene = GameScene.newGameScene()

        // Present the scene
        let skView = self.view as! SKView
        skView.presentScene(self.scene)
        
        skView.ignoresSiblingOrder = true
        skView.showsFPS = true
        skView.showsNodeCount = false
        
        loadSettings()
        
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
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onScoreBuffUpdate),
            name: .scoreBuffUpdate,
            object: nil)
        
        startGame()
        
        //uncomment to debug stuff
        //DebugPaletteCMD(self.gameModel!).run(); return
        
        if FileHelper.SaveFileExist() {
            LoadGameCMD(self.gameModel!).run()
        } else {
            //DebugPaletteCMD(self.gameModel!).run()
            AddRandomElementsCMD(self.gameModel!).run(
                cells: self.currentGameParams!.randomElementsCount,
                blocked: self.currentGameParams!.blockedCellsCount)
        }
    }
    
    private func loadSettings() {
        
        let prefPalette = ColorSchemaType(rawValue: defaults.integer(forKey: SettingsKey.Palette.rawValue))
        let prefFieldSize = FieldSize(rawValue: defaults.integer(forKey: SettingsKey.FieldSize.rawValue))
        let prefMotionBlur = MotionBlurStatus(rawValue: defaults.integer(forKey: SettingsKey.MotionBlur.rawValue))
        let prefHapticFeedback = HapticFeedbackStatus(rawValue: defaults.integer(forKey: SettingsKey.HapticFeedback.rawValue))
        
        self.currentGameParams = GameParams(
            fieldSize: prefFieldSize ?? self.defaultGameParams.fieldSize,
            randomElementsCount: self.defaultGameParams.randomElementsCount,
            blockedCellsCount: self.defaultGameParams.blockedCellsCount,
            motionBlur: prefMotionBlur ?? self.defaultGameParams.motionBlur,
            hapticFeedback: prefHapticFeedback ?? self.defaultGameParams.hapticFeedback,
            strategy: self.defaultGameParams.strategy,
            palette: prefPalette ?? self.defaultGameParams.palette)
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        let pal : IPaletteManager? = ContainerConfig.instance.tryResolve()
        return pal?.statusBarStyle() ?? .`default`
    }
    
    private func loadPalette() {
        
        let pal : IPaletteManager = PaletteManager()
        ContainerConfig.instance.register(pal)
    }
    
    private func startGame() {
        
        let cmd = StartGameCMD(
            scene: self.scene!,
            view: self.view as! SKView,
            params: self.currentGameParams!)
        cmd.run()
        
        self.gameModel = cmd.gameModel
        ContainerConfig.instance.register(self.gameModel!)
        setSceneColor()
        updateScoreLabel()
    }
    
    @objc func onGameReset(notification: Notification) {
        
        CleanGameCMD(self.gameModel!).run()
        loadSettings()
        startGame()
        AddRandomElementsCMD(self.gameModel!).run(
            cells: self.currentGameParams!.randomElementsCount,
            blocked: self.currentGameParams!.blockedCellsCount)
    }
    
    @objc func onScoreUpdate(notification: Notification) {
        
        updateScoreLabel()
    }
    
    private func updateScoreLabel() {
        
        scoreLabel.text = "\(self.gameModel!.score)"
    }
    
    @objc func onGameEnd(notification: Notification) {
        
        Timer.scheduledTimer(
            timeInterval: GameConstants.GameOverScreenDelay,
            target: self,
            selector: #selector(GameVC.showEndGameVC),
            userInfo: nil,
            repeats: false)
    }
    
    @objc func onColorChange(notification: Notification) {
        
        setSceneColor()
    }
    
    @objc func onScoreBuffUpdate(notification: Notification) {
        
        let multiplier = notification.object as? Int ?? 1
        scoreMultiplierLabel.text = multiplier == 1 ?
            "" : "X\(multiplier)"
    }
    
    private func setSceneColor() {
        
        let pal : IPaletteManager = ContainerConfig.instance.resolve()
        
        //@todo: find, how it works, may be it would be possible to use to switch palette with animation
        /*UIView.animate(withDuration: 1.0) {
            
        }*/
        
        setNeedsStatusBarAppearanceUpdate()
        
        self.scene?.backgroundColor = pal.sceneBgColor()
        if let fieldOutine = self.scene?.childNode(withName: FieldOutline.defaultNodeName) as? FieldOutline {
            fieldOutine.updateColor(color: pal.fieldOutlineColor())
        }
    }
    
    @objc private func showEndGameVC() {
        let storyboardName = "Main"
        let endGameVcName = "GameOverVC"
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: endGameVcName)
        
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        
        self.present(vc, animated: true, completion: nil)
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
