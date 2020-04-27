
//
//  GameViewController.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 10.04.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import GameplayKit
import SpriteKit
import UIKit

class GameVC: UIViewController {
	@IBOutlet var scoreLabel: UILabel!
	@IBOutlet var scoreMultiplierLabel: UILabel!
	
	@IBOutlet var yUpBtn: UIButton!
	@IBOutlet var leftBtn: UIButton!
	@IBOutlet var xDownBtn: UIButton!
	@IBOutlet var xUpBtn: UIButton!
	@IBOutlet var rightBtn: UIButton!
	@IBOutlet var yDownBtn: UIButton!
	
	var gameModel: GameModel?
	var scene: GameScene?
	
	// @todo: disable haptic and blur models olther than (?) 6s/SE
	let defaultGameParams = GameParams(
		fieldSize: FieldSize.Quaddro,
		randomElementsCount: 4,
		blockedCellsCount: 2,
		motionBlur: MotionBlurStatus.Enabled,
		hapticFeedback: HapticFeedbackStatus.Enabled,
		strategy: .Hybrid,
		palette: .Dark,
		stressTimer: StressTimerStatus.Enabled,
		useButtons: UseButtonStatus.Disabled)
	
	let defaults = UserDefaults.standard
	
	// MARK: UIViewController things
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let shaderManager: IShaderManager = ShaderManager()
		ContainerConfig.instance.register(shaderManager)
		
		self.scene = GameScene(size: self.view.frame.size)
		self.scene?.shaderManager = shaderManager
		
		// Present the scene
		let skView = self.view as! SKView
		skView.presentScene(self.scene)
		
		skView.ignoresSiblingOrder = true
		skView.showsFPS = true
		skView.showsNodeCount = false
		
		self.registerObservers()
		self.startGame()
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		self.scene?.updateSafeArea(
			bounds: UIScreen.main.bounds,
			insects: view.safeAreaInsets)
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
		let pal: IPaletteManager? = ContainerConfig.instance.tryResolve()
		return pal?.statusBarStyle() ?? .default
	}
	
	// MARK: Game starters
	
	private func createModel(_ params: GameParams) {
		let strategy = MerginStrategyFabric.createByName(params.strategy)
		strategy.prefilValues(maxIndex: params.fieldSize.cellsCount)
		
		self.gameModel = GameModel(
			screenWidth: view.frame.width,
			fieldSize: params.fieldSize.rawValue,
			strategy: strategy,
			motionBlur: params.motionBlur == MotionBlurStatus.Enabled,
			hapticFeedback: params.hapticFeedback == HapticFeedbackStatus.Enabled,
			timerEnabled: params.stressTimer == StressTimerStatus.Enabled,
			useButtons: params.useButtons == UseButtonStatus.Enabled)
		self.gameModel?.collectableBonuses.removeAll()
		ContainerConfig.instance.register(self.gameModel!)
	}
	
	private func loadSettings(fieldSizeFromSave: FieldSize?) -> GameParams {
		let prefPalette = ColorSchemaType(rawValue: defaults.integer(forKey: SettingsKey.Palette.rawValue))
		let prefFieldSize = FieldSize(rawValue: defaults.integer(forKey: SettingsKey.FieldSize.rawValue))
		let prefMotionBlur = MotionBlurStatus(rawValue: defaults.integer(forKey: SettingsKey.MotionBlur.rawValue))
		let prefHapticFeedback = HapticManager.isSupported()
			? HapticFeedbackStatus(rawValue: self.defaults.integer(forKey: SettingsKey.HapticFeedback.rawValue))
			: .Disabled
		
		let prefStress = StressTimerStatus(rawValue: defaults.integer(forKey: SettingsKey.StressTimer.rawValue))
		let useButtons = UseButtonStatus(rawValue: defaults.integer(forKey: SettingsKey.UseButtons.rawValue))
		
		return GameParams(
			fieldSize: (fieldSizeFromSave ?? prefFieldSize) ?? self.defaultGameParams.fieldSize,
			randomElementsCount: self.defaultGameParams.randomElementsCount,
			blockedCellsCount: self.defaultGameParams.blockedCellsCount,
			motionBlur: prefMotionBlur ?? self.defaultGameParams.motionBlur,
			hapticFeedback: prefHapticFeedback ?? self.defaultGameParams.hapticFeedback,
			strategy: self.defaultGameParams.strategy,
			palette: prefPalette ?? self.defaultGameParams.palette,
			stressTimer: prefStress ?? self.defaultGameParams.stressTimer,
			useButtons: useButtons ?? self.defaultGameParams.useButtons)
	}
	
	private func createPalette(_ palette: ColorSchemaType) {
		
		let actualPalette = palette.ensureDarkMode(traitCollection)
		
		let pal: IPaletteManager = PaletteManager(actualPalette)
		ContainerConfig.instance.register(pal)
	}
	
	private func addToScene(cell: BgCell) {
		self.scene?.addChild(cell)
	}
	
	private func updateSceneColor() {
		let pal: IPaletteManager = ContainerConfig.instance.resolve()
		
		setNeedsStatusBarAppearanceUpdate()
		
		let shaderManager: IShaderManager = ContainerConfig.instance.resolve()
		shaderManager.onPaletteUpdate()
		
		self.scene?.backgroundColor = pal.sceneBgColor()
		if let fieldOutine = self.scene?.childNode(withName: FieldOutline.defaultNodeName) as? FieldOutline {
			fieldOutine.updateColor(color: pal.fieldOutlineColor())
		}
	}
	
	// common parts between start and restart
	private func createGame(_ settings: GameParams) {
		self.switchButtons(hidden: settings.useButtons == UseButtonStatus.Disabled)
		self.createPalette(settings.palette)
		self.createModel(settings)
		
		let cmdFactory: ICmdFactory = GameCmdFactory(self.gameModel!)
		ContainerConfig.instance.register(cmdFactory)
		
		self.scene?.addFieldOutline(self.gameModel!)
		self.gameModel?.field.executeForAll(lambda: self.addToScene)
		self.updateSceneColor()
	}
	
	private func startGame() {
		let save = FileHelper.loadSave() // @todo: use FileHelper by interface ?
		let settings = self.loadSettings(fieldSizeFromSave: save?.fieldSize)
		self.createGame(settings)
		
		if settings.palette == .Dark {
			overrideUserInterfaceStyle = .dark
		} else if settings.palette == .Light {
			overrideUserInterfaceStyle = .light
		}
		
		// DebugPaletteCMD(self.gameModel!).run()
		if save != nil {
			CmdFactory().LoadGame(save: save!).run()
		} else {
			CmdFactory()
				.AddRandomElements(
					cells: settings.randomElementsCount,
					blocked: settings.blockedCellsCount)
				.run()
		}
		
		// Delay one second because random cells appers with random delay
		_ = CmdFactory().CheckGameEnd().runWithDelay(delay: 1.0)
		
		for bonus in self.gameModel!.collectableBonuses {
			NotificationCenter.default.post(name: .updateCollectables, object: bonus.key)
		}
		
		// self.scene!.addTestNode()
	}
	
	private func restartGame() {
		CmdFactory().CleanGame().run()
		let settings = self.loadSettings(fieldSizeFromSave: nil)
		self.createGame(settings)
		
		CmdFactory()
			.AddRandomElements(
				cells: settings.randomElementsCount,
				blocked: settings.blockedCellsCount)
			.run()
		
		NotificationCenter.default.post(
			name: .updateScore,
			object: self.gameModel?.score)
		self.scene?.panel?.removeAllButtons()
	}
	
	// MARK: Callbacks
	
	private func registerObservers() {
		let recognizer = HexSwipeGestureRecogniser(
			target: self,
			action: #selector(self.handleSwipe(recognizer:)))
		recognizer.delegate = self
		self.view.addGestureRecognizer(recognizer)
		
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(self.onGameReset),
			name: .resetGame,
			object: nil)
		
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(self.onGameEnd),
			name: .gameOver,
			object: nil)
		
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(self.onColorChange),
			name: .switchPalette,
			object: nil)
		
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(self.onScoreBuffUpdate),
			name: .scoreBuffUpdate,
			object: nil)
		
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(self.onUseButtonsChange),
			name: .switchUseButtons,
			object: nil)
	}
	
	@objc func onGameReset(notification: Notification) {
		self.restartGame()
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
		self.updateSceneColor()
	}
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        guard UIApplication.shared.applicationState == .inactive else {
            return
        }
		
		if traitCollection.userInterfaceStyle == previousTraitCollection?.userInterfaceStyle {
			return
		}
		
		if defaults.integer(forKey: SettingsKey.Palette.rawValue) == ColorSchemaType.Auto.rawValue {
			if traitCollection.userInterfaceStyle == .dark {
				SwitchPaletteCMD(self.gameModel!).run(.Dark)
			}
			else if traitCollection.userInterfaceStyle == .light {
				SwitchPaletteCMD(self.gameModel!).run(.Light)
			}
		}
    }
	
	@objc func onScoreBuffUpdate(notification: Notification) {
		let multiplier = notification.object as? Int ?? 1
		self.scoreMultiplierLabel.text = multiplier == 1 ?
			"" : "X\(multiplier)"
	}
	
	@objc func onUseButtonsChange(notification: Notification) {
		let use = notification.object as? Bool ?? false
		self.switchButtons(hidden: !use)
	}
	
	private func switchButtons(hidden: Bool) {
		self.xDownBtn.isHidden = hidden
		self.yUpBtn.isHidden = hidden
		self.leftBtn.isHidden = hidden
		self.xUpBtn.isHidden = hidden
		self.rightBtn.isHidden = hidden
		self.yDownBtn.isHidden = hidden
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
	
	private func handleSwipe(direction: SwipeDirection) {
		CmdFactory().DoSwipe(direction: direction).run()
		CmdFactory().ApplyScoreBuff().run()
		_ = CmdFactory().AfterSwipe().runWithDelay(delay: self.gameModel!.swipeStatus.delay)
	}
	
	@IBAction func onXDownBtnClick(_ sender: Any) {
		self.handleSwipe(direction: .XDown)
	}
	
	@IBAction func onYUpBtnClick(_ sender: Any) {
		self.handleSwipe(direction: .YUp)
	}
	
	@IBAction func onXUpClick(_ sender: Any) {
		self.handleSwipe(direction: .XUp)
	}
	
	@IBAction func onLeftBtnClick(_ sender: Any) {
		self.handleSwipe(direction: .Left)
	}
	
	@IBAction func onRightClick(_ sender: Any) {
		self.handleSwipe(direction: .Right)
	}
	
	@IBAction func onYDownClick(_ sender: Any) {
		self.handleSwipe(direction: .YDown)
	}
}

// MARK: Gesture recognizer

extension GameVC: UIGestureRecognizerDelegate {
	@objc func handleSwipe(recognizer: HexSwipeGestureRecogniser) {
		self.handleSwipe(direction: recognizer.direction)
	}
	
	// https://stackoverflow.com/questions/4825199/gesture-recognizer-and-button-actions
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
		// @todo: check performance here. May be compare with existing button instead of casting?
		if let scene = self.scene {
			let nodes = scene.nodes(at: touch.location(in: scene))
			for node in nodes {
				if let button = node as? CollectableBtn {
					button.onClick()
					return false
				}
				
				if let bgCell = node as? BgCell {
					if bgCell.canBeSelected {
						CmdFactory()
							.TouchSelectableCell()
							.setup(node: bgCell)
							.run()
						return false
					}
				}
			}
		}
		
		if touch.view is UIButton {
			return false
		}
		
		if self.gameModel?.useButtonsEnabled == true {
			return false
		}
		
		if let swipeStatus = self.gameModel?.swipeStatus {
			if swipeStatus.isInProgressOrLocked() {
				return false
			}
		}
		
		return true
	}
}
