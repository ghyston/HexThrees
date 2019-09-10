//
//  PauseVC.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 28.06.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation
import UIKit

class PauseVC : UIViewController {
    
    var gameModel : GameModel?
    let defaults = UserDefaults.standard

    @IBOutlet weak var hapticFeedbackStackView: UIStackView!
    @IBOutlet weak var fieldSizeValueLabel: UILabel!
    @IBOutlet weak var fieldSizeStepper: UIStepper!
    @IBOutlet weak var paletteChanger: UISegmentedControl!
    @IBOutlet weak var motionBlurSwitch: UISwitch!
    @IBOutlet weak var hapticFeedbackSwitch: UISwitch!
    @IBOutlet weak var timerSwitch: UISwitch!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var warningLabel: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.gameModel = ContainerConfig.instance.resolve() as GameModel
        let settingsFieldSize = defaults.integer(forKey: SettingsKey.FieldSize.rawValue)
        
        fieldSizeStepper.minimumValue = Double(FieldSize.Thriple.rawValue)
        fieldSizeStepper.maximumValue = Double(FieldSize.Pento.rawValue)
	        fieldSizeStepper.value = Double(settingsFieldSize > 0 ? settingsFieldSize : (gameModel?.field.height)!)
        updateStepperValueLabel()
        
        motionBlurSwitch.isOn = gameModel?.motionBlurEnabled ?? false
        hapticFeedbackSwitch.isOn = gameModel?.hapticManager.isEnabled ?? false
        timerSwitch.isOn = gameModel?.stressTimer.isEnabled() ?? false
        
        updateWarningLabel()
        setupSegmentedControlDesign()
    }
    
    @IBAction func onSwipeRight(_ sender: UISwipeGestureRecognizer) {
        
        dismiss(animated: true, completion: nil)
    }
    
    private func setupSegmentedControlDesign() {
        
        paletteChanger.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont(name: "Futura", size: 22)!,
            NSAttributedString.Key.foregroundColor: UIColor.darkGray
            ], for: .normal)
        
        paletteChanger.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont(name: "Futura", size: 20)!,
            NSAttributedString.Key.foregroundColor: UIColor.white
            ], for: .selected)
        
        let oldPlette = ColorSchemaType(rawValue: defaults.integer(forKey: SettingsKey.Palette.rawValue))
        
        switch oldPlette {
        case .Gray?:
            paletteChanger.selectedSegmentIndex = 1
        case .Light?:
            paletteChanger.selectedSegmentIndex = 2
        case .Dark?:
            paletteChanger.selectedSegmentIndex = 0
        default:
            paletteChanger.selectedSegmentIndex = 0
            return
        }
    }
        
    private func updateStepperValueLabel() {
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 0
        fieldSizeValueLabel.text = formatter.string(from: fieldSizeStepper.value as NSNumber)
    }
    
    private func updateWarningLabel() {
        
        let alpha = CGFloat(Int(fieldSizeStepper.value) == gameModel?.field.width ? 0.1 : 0.9)
        let color = warningLabel.textColor.withAlphaComponent(alpha)
        
        warningLabel.textColor = color
    }
    
    @IBAction func onHapticFeedbackChanged(_ sender: Any) {
        
        guard let gm = self.gameModel else {
            return
        }
        
        let hapticFeedbackStatus = hapticFeedbackSwitch.isOn ?
            HapticFeedbackStatus.Enabled :
            HapticFeedbackStatus.Disabled
        
        defaults.set(hapticFeedbackStatus.rawValue, forKey: SettingsKey.HapticFeedback.rawValue)
        SwitchHapticFeedbackCMD(gm).run(isOn: hapticFeedbackSwitch.isOn)
    }
    
    @IBAction func onMotionBlurChanged(_ sender: Any) {
        
        guard let gm = self.gameModel else {
            return
        }
        
        let motionBlurStatus = motionBlurSwitch.isOn ?
            MotionBlurStatus.Enabled :
            MotionBlurStatus.Disabled
        
        defaults.set(motionBlurStatus.rawValue, forKey: SettingsKey.MotionBlur.rawValue)
        SwitchMotionBlurCMD(gm).run(isOn: motionBlurSwitch.isOn)
    }
    
    @IBAction func onTimerChanged(_ sender: Any) {
        let timerStatus = timerSwitch.isOn ?
            StressTimerStatus.Enabled :
            StressTimerStatus.Disabled
        
        defaults.set(timerStatus.rawValue, forKey: SettingsKey.StressTimer.rawValue)
        guard let timer = self.gameModel?.stressTimer else {
            return
        }
        
        if timerStatus == StressTimerStatus.Enabled && !timer.isEnabled() {
            timer.enable()
        }
        else if timerStatus == StressTimerStatus.Disabled && timer.isEnabled() {
            timer.disable()
        }
    }
    
    @IBAction func onCancel(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onFieldSizeChanged(_ sender: Any) {
        
        updateWarningLabel()
        updateStepperValueLabel()
        defaults.set(Int(fieldSizeStepper.value), forKey: SettingsKey.FieldSize.rawValue)
    }
    
    @IBAction func onPaletteChanged(_ sender: Any) {
        
        guard let gm = self.gameModel else {
            return
        }
        
        let newMode : ColorSchemaType
        switch paletteChanger.selectedSegmentIndex {
        case 0:
            newMode = .Dark
        case 1:
            newMode = .Gray
        case 2:
            newMode = .Light
        default:
            return
        }
        
        SwitchPaletteCMD(gm).run(newMode)
        defaults.set(newMode.rawValue, forKey: SettingsKey.Palette.rawValue)
    }
    
    @IBAction func onReset(_ sender: Any) {
        
        NotificationCenter.default.post(name: .resetGame, object: nil)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClose(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
}
