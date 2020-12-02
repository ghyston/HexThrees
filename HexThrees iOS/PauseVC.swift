//
//  PauseVC.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 28.06.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation
import UIKit

// copied from https://stackoverflow.com/a/49975845/1741428
public extension UIButton {
	func alignTextBelow(spacing: CGFloat = 6.0) {
		if let image = imageView?.image {
			let imageSize: CGSize = image.size
			titleEdgeInsets = UIEdgeInsets(top: spacing, left: -imageSize.width, bottom: -imageSize.height, right: 0.0)
			let labelString = NSString(string: titleLabel!.text!)
			let titleSize = labelString.size(withAttributes: [NSAttributedString.Key.font: titleLabel!.font!])
			imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0.0, bottom: 0.0, right: -titleSize.width)
		}
	}
}

class PauseVC: UIViewController {
	var gameModel: GameModel?
	let defaults = UserDefaults.standard
	
	@IBOutlet var hapticFeedbackStackView: UIStackView!
	@IBOutlet var paletteChanger: UISegmentedControl!
	@IBOutlet var motionBlurSwitch: UISwitch!
	@IBOutlet var hapticFeedbackSwitch: UISwitch!
	@IBOutlet var timerSwitch: UISwitch!
	@IBOutlet var useButtonsSwitch: UISwitch!
	
	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var bestScoreLabel: UILabel!
	@IBOutlet var versionLabel: UILabel!
	
	@IBOutlet var backButton: UIButton!
	@IBOutlet var helpButton: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if !HapticManager.isSupported() {
			hapticFeedbackStackView.isHidden = true
		}
		
		gameModel = ContainerConfig.instance.resolve() as GameModel
		
		motionBlurSwitch.isOn = gameModel?.motionBlurEnabled ?? false
		hapticFeedbackSwitch.isOn = gameModel?.hapticManager.isEnabled ?? false
		timerSwitch.isOn = gameModel?.stressTimer.isEnabled() ?? false
		useButtonsSwitch.isOn = gameModel?.useButtonsEnabled ?? false
		
		setupSegmentedControlDesign()
		
		let bestScore = UserDefaults.standard.integer(forKey: SettingsKey.BestScore.rawValue)
		if bestScore > 0 {
            bestScoreLabel.text = "pause.bestScore".localizedWithFormat(arguments: bestScore)
		}
		
		
		let bundleShortVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
		let bundleVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "" //build number
		let isTrial = gameModel?.purchased == true ? "" : "Trial"
		versionLabel.text = "\(isTrial) v.\(bundleShortVersion) \(bundleVersion)"
	}
	
	@IBAction func onSwipeRight(_ sender: UISwipeGestureRecognizer) {
		dismiss(animated: true, completion: nil)
	}
	
	private func setupSegmentedControlDesign() {
		paletteChanger.setTitleTextAttributes([
			NSAttributedString.Key.font: UIFont(name: "Futura", size: 22)!,
			NSAttributedString.Key.foregroundColor: UIColor.darkGray
		], for: .normal)
		
		paletteChanger.setTitleTextAttributes([
			NSAttributedString.Key.font: UIFont(name: "Futura", size: 20)!,
			NSAttributedString.Key.foregroundColor: UIColor.white
		], for: .selected)
		
		let oldPalette = ColorSchemaType(rawValue: defaults.integer(forKey: SettingsKey.Palette.rawValue))
		switch oldPalette {
		case .Dark?:
			paletteChanger.selectedSegmentIndex = 0
		case .Light?:
			paletteChanger.selectedSegmentIndex = 1
		case .Auto?:
			paletteChanger.selectedSegmentIndex = 2
		default:
			paletteChanger.selectedSegmentIndex = 2
			return
		}
	}
	
	@IBAction func onHapticFeedbackChanged(_ sender: Any) {
		guard let gm = gameModel else {
			return
		}
		
		SwitchHapticFeedbackCMD(gm).run(isOn: hapticFeedbackSwitch.isOn)
	}
	
	@IBAction func onMotionBlurChanged(_ sender: Any) {
		guard let gm = gameModel else {
			return
		}
		
		SwitchMotionBlurCMD(gm).run(isOn: motionBlurSwitch.isOn)
	}
	
	@IBAction func onTimerChanged(_ sender: Any) {
		let timerStatus = timerSwitch.isOn ?
			StressTimerStatus.Enabled :
			StressTimerStatus.Disabled
		
		defaults.set(timerStatus.rawValue, forKey: SettingsKey.StressTimer.rawValue)
		guard let timer = gameModel?.stressTimer else {
			return
		}
		
		if timerStatus == StressTimerStatus.Enabled, !timer.isEnabled() {
			timer.enable()
		}
		else if timerStatus == StressTimerStatus.Disabled, timer.isEnabled() {
			timer.disable()
		}
	}
	
	@IBAction func onCancel(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}
	
	@IBAction func onPaletteChanged(_ sender: Any) {
		guard let gm = gameModel else {
			return
		}
		
		let newMode: ColorSchemaType
		switch paletteChanger.selectedSegmentIndex {
		case 0:
			newMode = .Dark
		case 1:
			newMode = .Light
		case 2:
			newMode = .Auto
		default:
			return
		}
		
		SwitchPaletteCMD(gm).run(newMode.ensureDarkMode(traitCollection))
		defaults.set(newMode.rawValue, forKey: SettingsKey.Palette.rawValue)
	}
	
	@IBAction func onUseButtonsSwitch(_ sender: Any) {
		guard let gm = gameModel else {
			return
		}
		
		SwitchUseButtonsCmd(gm).run(isOn: useButtonsSwitch.isOn)
	}
	
	@IBAction func onReset(_ sender: Any) {
		let restartAlert = UIAlertController(
            title: "",//pause.restartTitle".localized(),
            message: "pause.restartDescription".localized(),
			preferredStyle: UIAlertController.Style.alert)
		
		restartAlert.addAction(UIAlertAction(
            title: "common.yes".localized(),
			style: .destructive,
			handler: onConfirmReset))
		
		restartAlert.addAction(UIAlertAction(
            title: "common.cancel".localized(),
			style: .cancel,
			handler: nil))
		
		present(restartAlert, animated: true, completion: nil)
	}
	
	func onConfirmReset(action: UIAlertAction) {
		NotificationCenter.default.post(name: .resetGame, object: nil)
		dismiss(animated: true, completion: nil)
	}
	
	@IBAction func onClose(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}
}
