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
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var warningLabel: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.gameModel = ContainerConfig.instance.resolve() as GameModel
        
        fieldSizeStepper.minimumValue = Double(FieldSize.Thriple.rawValue)
        fieldSizeStepper.maximumValue = Double(FieldSize.Pento.rawValue)
        fieldSizeStepper.value = Double((gameModel?.fieldHeight)!)
        updateStepperValueLabel()
        
        motionBlurSwitch.isOn = gameModel?.motionBlurEnabled ?? false
        hapticFeedbackSwitch.isOn = gameModel?.hapticManager.isEnabled ?? false
        
        updateWarningLabel()
        setupSegmentedControlDesign()
    }
    
    @IBAction func onSwipeRight(_ sender: UISwipeGestureRecognizer) {
        
        dismiss(animated: true, completion: nil)
    }
    
    private func setupSegmentedControlDesign() {
        
        paletteChanger.setTitleTextAttributes([
            NSAttributedStringKey.font : UIFont(name: "Futura", size: 22)!,
            NSAttributedStringKey.foregroundColor: UIColor.darkGray
            ], for: .normal)
        
        paletteChanger.setTitleTextAttributes([
            NSAttributedStringKey.font : UIFont(name: "Futura", size: 20)!,
            NSAttributedStringKey.foregroundColor: UIColor.white
            ], for: .selected)
        
        //@todo: load palette info here
    }
        
    private func updateStepperValueLabel() {
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 0
        fieldSizeValueLabel.text = formatter.string(from: fieldSizeStepper.value as NSNumber)
    }
    
    private func updateWarningLabel() {
        
        let alpha = CGFloat(Int(fieldSizeStepper.value) == gameModel?.fieldWidth ? 0.1 : 0.9)
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
