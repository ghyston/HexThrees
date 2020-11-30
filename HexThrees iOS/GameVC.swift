
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
	
	let defaultGameParams = GameParams(
		randomElementsCount: 4,
		blockedCellsCount: 2,
		motionBlur: MotionBlurStatus.Enabled,
		hapticFeedback: HapticFeedbackStatus.Enabled,
		strategy: .Hybrid,
		palette: .Auto,
		stressTimer: StressTimerStatus.Enabled,
		useButtons: UseButtonStatus.Disabled,
		purchased: false)
	
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
		skView.showsFPS = false
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
		strategy.prefilValues(maxIndex: GameConstants.MaxFieldSize * GameConstants.MaxFieldSize)
		
		self.gameModel = GameModel(
			strategy: strategy,
			motionBlur: params.motionBlur == MotionBlurStatus.Enabled,
			hapticFeedback: params.hapticFeedback == HapticFeedbackStatus.Enabled,
			timerEnabled: params.stressTimer == StressTimerStatus.Enabled,
			useButtons: params.useButtons == UseButtonStatus.Enabled,
			purchased: params.purchased)
		self.gameModel?.collectableBonuses.removeAll()
		ContainerConfig.instance.register(self.gameModel!)
	}
	
	private func loadSettings() -> GameParams {
		let prefPalette = ColorSchemaType(rawValue: defaults.integer(forKey: SettingsKey.Palette.rawValue))
		let prefMotionBlur = MotionBlurStatus(rawValue: defaults.integer(forKey: SettingsKey.MotionBlur.rawValue))
		let prefHapticFeedback = HapticManager.isSupported()
			? HapticFeedbackStatus(rawValue: self.defaults.integer(forKey: SettingsKey.HapticFeedback.rawValue))
			: .Disabled
		
		let prefStress = StressTimerStatus(rawValue: defaults.integer(forKey: SettingsKey.StressTimer.rawValue))
		let useButtons = UseButtonStatus(rawValue: defaults.integer(forKey: SettingsKey.UseButtons.rawValue))
		
		return GameParams(
			randomElementsCount: self.defaultGameParams.randomElementsCount,
			blockedCellsCount: self.defaultGameParams.blockedCellsCount,
			motionBlur: prefMotionBlur ?? self.defaultGameParams.motionBlur,
			hapticFeedback: prefHapticFeedback ?? self.defaultGameParams.hapticFeedback,
			strategy: self.defaultGameParams.strategy,
			palette: prefPalette ?? self.defaultGameParams.palette,
			stressTimer: prefStress ?? self.defaultGameParams.stressTimer,
			useButtons: useButtons ?? self.defaultGameParams.useButtons,
			purchased: defaults.bool(forKey: SettingsKey.Purchased.rawValue))
	}
	
	private func createPalette(_ palette: ColorSchemaType) {
		let actualPalette = palette.ensureDarkMode(traitCollection)
		
		let pal: IPaletteManager = PaletteManager(actualPalette)
		ContainerConfig.instance.register(pal)
	}
	
	private func updateSceneColor() {
		let pal: IPaletteManager = ContainerConfig.instance.resolve()
		
		setNeedsStatusBarAppearanceUpdate()
		
		let shaderManager: IShaderManager = ContainerConfig.instance.resolve()
		shaderManager.onPaletteUpdate()
		
		self.scene?.backgroundColor = pal.sceneBgColor()
		if let fieldOutine = self.scene?.fieldOutline {
			fieldOutine.updateColor(color: pal.fieldOutlineColor())
		}
	}
	
	// @todo: I'm not proud of my next 100+ lines about create/start/restart, but these parts changes too often to make them clear
	// common parts between start and restart
	private func createGame(_ settings: GameParams) {
		self.switchButtons(hidden: settings.useButtons == UseButtonStatus.Disabled)
		self.createPalette(settings.palette)
		self.createModel(settings)
		self.loadStoreProducts()
		
		let cmdFactory: ICmdFactory = GameCmdFactory(self.gameModel!)
		ContainerConfig.instance.register(cmdFactory)
	}
	
	private func addFieldToScene() {
		self.scene?.addFieldOutline(self.gameModel!)
		self.gameModel?.field.executeForAll(lambda: {
			self.scene?.addChild($0)
			$0.playAppearAnimation(
				duration: GameConstants.CellAppearAnimationDuration * Double.random(in: 0.5 ... 1.2),
				delay: GameConstants.CellAppearAnimationDuration * 0.5)
		})
		self.updateSceneColor()
	}
	
	private func startGame() {
		let save = FileHelper.loadSave() // @todo: use FileHelper by interface ?
		let settings = self.loadSettings()
		self.createGame(settings)
		
		if settings.palette == .Dark {
			overrideUserInterfaceStyle = .dark
		} else if settings.palette == .Light {
			overrideUserInterfaceStyle = .light
		}
		
		// DebugPaletteCMD(self.gameModel!).run()
		let tutorialManager = self.gameModel!.tutorialManager
		
		if !tutorialManager.alreadyRun() {
			self.createTutorialGame()
			tutorialManager.start(model: self.gameModel!)
		} else if let save = save {
			LoadGameCmd(self.gameModel!, save: save, screen: view.frame.size).run()
		} else {
			self.createNewGame(settings)
		}
		
		self.addFieldToScene()
		
		// Delay one second because random cells appers with random delay
		let gameEndCheck = CmdFactory().CheckGameEnd().runWithDelay(delay: 1.0)
		
		for bonus in self.gameModel!.collectableBonuses {
			NotificationCenter.default.post(name: .updateCollectables, object: bonus.key)
		}
		
		if self.gameModel!.freeLimitReached() {
			gameEndCheck.invalidate()
			_ = ShowPurchasePopupCmd(gameModel!).runWithDelay(delay: 1.0)
			return
		}
	}
	
	private func loadStoreProducts() {
		RequestStoreProductCMD(self.gameModel!).run()
	}
	
	private func createTutorialGame() {
		self.gameModel!.field.setupNewField(
			model: self.gameModel!,
			screenSize: view.frame.size)
	}
	
	private func createNewGame(_ settings: GameParams) {
		self.gameModel!.field.setupNewField(
			model: self.gameModel!,
			screenSize: view.frame.size)
		
		CmdFactory()
			.AddRandomElements(
				cells: settings.randomElementsCount,
				blocked: settings.blockedCellsCount)
			.run()
		/*
		// commented code below shows all bonus acions
		// set fieldsize on setupNewField and block loadGame
		let bonuses = [
			16: BonusType.UNLOCK_CELL,
			17: BonusType.BLOCK_CELL,
			18: BonusType.X2_POINTS,
			23: BonusType.X3_POINTS,
			24: BonusType.COLLECTABLE_UNLOCK_CELL,
			25: BonusType.COLLECTABLE_PAUSE_TIMER,
			30: BonusType.COLLECTABLE_SWIPE_BLOCK,
			31: BonusType.COLLECTABLE_PICK_UP,
			32: BonusType.EXPAND_FIELD
		]
		
		for bonus in bonuses {
			self.gameModel?.field[bonus.key]?.addBonus(BonusFabric.createBy(bonus: bonus.value, gameModel: self.gameModel!))
		}*/
	}
	
	private func restartGame() {
		CmdFactory().CleanGame().run()
		let settings = self.loadSettings()
		self.createGame(settings)
		// @todo: do we need to recheck style appearence?
		
		self.createNewGame(settings)
		self.addFieldToScene()
		
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
		
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(self.onFieldExpand),
			name: .expandField,
			object: nil)
		
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(self.onFreeLimitReached),
			name: .freeLimitReached,
			object: nil)
		
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(self.onPurchaseSuccessfull),
			name: .purchaseSuccessfull,
			object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.onRestoreSuccessfull),
            name: .restoreSuccessfull,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.onRestoreFailed),
            name: .restoreFailed,
            object: nil)
		
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(self.onPurchaseFailed),
			name: .purchaiseFailed,
			object: nil)
		
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(self.showProductNotFoundPopup),
			name: .productNotFound,
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
		
		if self.defaults.integer(forKey: SettingsKey.Palette.rawValue) == ColorSchemaType.Auto.rawValue {
			if traitCollection.userInterfaceStyle == .dark {
				SwitchPaletteCMD(self.gameModel!).run(.Dark)
			} else if traitCollection.userInterfaceStyle == .light {
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
	
	@objc func onFieldExpand(notification: Notification) {
		let cmd = ExpandHexFieldCmd(self.gameModel!)
		cmd.setup(
			viewSize: view.frame.size,
			scene: self.scene!)
		cmd.run()
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
	
	@objc private func onFreeLimitReached() {
		guard !gameModel!.purchased else {
			return
		}
		
		guard IAPHelper.shared.canBePurchased() else {
			showUnableToPurchasePopup()
			return
		}
		
		guard IAPHelper.shared.productIsSet() else {
			showProductNotFoundPopup()
			return
		}
		
		showPurchasePopup()
	}
	
	private func handleSwipe(direction: SwipeDirection) {
		guard self.gameModel!.swipeStatus.isAllowed(direction) else {
			return
		}
		
		// @todo: call to tutorial manager
		
		DoSwipeCmd(self.gameModel!).setup(direction: direction).run()
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

// MARK: Purchasement UI

extension GameVC {
	private func showPurchasePopup() {
		let limitAlert = UIAlertController(
			title: "Purchase",
			message: "You reached limit of free HexTrees version. Would you like to unlock full version?",
			preferredStyle: UIAlertController.Style.alert)
		
		limitAlert.addAction(UIAlertAction(
			title: "Reset game",
			style: .destructive,
			handler: onConfirmReset))
		
		let price = IAPHelper.shared.getFullVersionPriceFormatted() ?? "??"
		
		limitAlert.addAction(UIAlertAction(
			title: "Unlock full version for \(price)",
			style: .default,
			handler: onPurchaseClick))
		
		limitAlert.addAction(UIAlertAction(
			title: "Restore purchases",
			style: .default,
			handler: onRestoreClick))
		
		present(limitAlert, animated: true, completion: nil)
	}
	
	private func showUnableToPurchasePopup() {
		let alert = UIAlertController(
			title: "Purchase",
			message: "In-app purchases are not allowed",
			preferredStyle: UIAlertController.Style.alert)
		
		alert.addAction(UIAlertAction(
			title: "Reset game",
			style: .destructive,
			handler: onConfirmReset))
		
		present(alert, animated: true, completion: nil)
	}
	
	@objc private func showProductNotFoundPopup() {
		let alert = UIAlertController(
			title: "Purchase",
			message: "AppStore full version product not found",
			preferredStyle: UIAlertController.Style.alert)
		
		alert.addAction(UIAlertAction(
			title: "Reset game",
			style: .destructive,
			handler: onConfirmReset))
		
		present(alert, animated: true, completion: nil)
	}
	
	private func onConfirmReset(action: UIAlertAction) {
		restartGame()
	}
	
	private func onPurchaseClick(action: UIAlertAction) {
		startLoadingSpinner()
		PurchaseFullVersionCmd(self.gameModel!).run()
	}
	
	private func onRestoreClick(action: UIAlertAction) {
        startLoadingSpinner()
		RestorePurchaseCmd(self.gameModel!).run()
	}
	
	@objc private func onPurchaseSuccessfull() {
		onHappyPurchase(customerMessage: "Thank you for purchaising HexThrees!")
	}
	
	@objc private func onRestoreSuccessfull() {
		onHappyPurchase(customerMessage: "Full version restored successfully")
	}
	
    @objc private func onRestoreFailed() {
        onSadRestore()
    }
    
	@objc private func onPurchaseFailed() {
		onSadPurchase(customerMessage: "Purchaise failed")
	}
	
	@objc func onPurchaseDeferred() {
		onSadPurchase(customerMessage: "Purchaise is deffered")
	}
	
	private func onHappyPurchase(customerMessage: String) {
        stopLoadingSpinner()
		FinalizeSuccPurchaseCMD(gameModel!).run()
		let alert = UIAlertController(
			title: "Full version",
			message: customerMessage,
			preferredStyle: UIAlertController.Style.alert)
		
		alert.addAction(UIAlertAction(
			title: "Continue to play",
			style: .default,
			handler: onContinuePlay))
		
		present(alert, animated: true, completion: nil)
	}
	
	private func onSadPurchase(customerMessage: String) {
		stopLoadingSpinner()
		let alert = UIAlertController(
			title: "Purchase",
			message: customerMessage,
			preferredStyle: UIAlertController.Style.alert)
		
		alert.addAction(UIAlertAction(
			title: "Reset game",
			style: .destructive,
			handler: onConfirmReset))
		
		alert.addAction(UIAlertAction(
			title: "Try again",
			style: .default,
			handler: onPurchaseClick))
		
		present(alert, animated: true, completion: nil)
	}
    
    private func onSadRestore() {
        stopLoadingSpinner()
        let alert = UIAlertController(
            title: "Restore",
            message: "Restoring purchases failed",
            preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(
            title: "Try again",
            style: .default,
            handler: onRestoreClick))
        
        let price = IAPHelper.shared.getFullVersionPriceFormatted() ?? "??"
        
        alert.addAction(UIAlertAction(
            title: "Unlock full version for \(price)",
            style: .default,
            handler: onPurchaseClick))
        
        alert.addAction(UIAlertAction(
            title: "Reset game",
            style: .destructive,
            handler: onConfirmReset))
        
        present(alert, animated: true, completion: nil)
    }
	
	private func onContinuePlay(action: UIAlertAction) {
		self.gameModel!.swipeStatus.unlockSwipes()
		CheckGameEndCmd(self.gameModel!).run()
	}
	
	private func startLoadingSpinner() {
		NotificationCenter.default.post(
			name: .showSpinner,
			object: gameModel!.geometry?.createBgCellShape())
	}
	
	private func stopLoadingSpinner() {
		NotificationCenter.default.post(
			name: .hideSpinner,
			object: nil)
	}
}

// MARK: Gesture recognizer

extension GameVC: UIGestureRecognizerDelegate {
	@objc func handleSwipe(recognizer: HexSwipeGestureRecogniser) {
		self.handleSwipe(direction: recognizer.direction)
	}
	
	// https://stackoverflow.com/questions/4825199/gesture-recognizer-and-button-actions
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
		guard let model = self.gameModel,
			let scene = self.scene else {
			return false
		}
		
		if model.tutorialManager.triggerForStep(
			model: model,
			steps: .HiglightFirstCell, .ShowTimer, .Last) {
			return false
		}
		
		// @todo: check performance here. May be compare with existing button instead of casting?
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
		
		// List of resaons, why swipe connot be proceded
		return !(touch.view is UIButton ||
			model.useButtonsEnabled ||
			model.swipeStatus.isInProgressOrLocked())
	}
}
