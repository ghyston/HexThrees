//
//  SettingsVC.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 01.07.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class SettingsVC :  UIViewController {
    
    var gameModel : GameModel?
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var fieldSizeValueLabel: UILabel!
    @IBOutlet weak var settingsPopupView: UIView!
    @IBOutlet weak var fieldSizeStepper: UIStepper!
    @IBOutlet weak var paletteChanger: UISegmentedControl!
    @IBOutlet weak var motionBlurSwitch: UISwitch!
    @IBOutlet weak var hapticFeedbackSwitch: UISwitch!
    
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
        
        let motionBlurStatus = motionBlurSwitch.isOn ? MotionBlurStatus.Enabled :
            MotionBlurStatus.Disabled
        
        defaults.set(motionBlurStatus.rawValue, forKey: SettingsKey.MotionBlur.rawValue)
        SwitchMotionBlurCMD(gm).run(isOn: motionBlurSwitch.isOn)
    }
    
    @IBAction func onCancel(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onFieldSizeChanged(_ sender: Any) {
        
        fieldSizeValueLabel.text = String(fieldSizeStepper.value)
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
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.gameModel = ContainerConfig.instance.resolve() as GameModel
        
        settingsPopupView.layer.cornerRadius = 20
        
        fieldSizeStepper.minimumValue = Double(FieldSize.Thriple.rawValue)
        fieldSizeStepper.maximumValue = Double(FieldSize.Pento.rawValue)
        
        fieldSizeStepper.value = Double((gameModel?.fieldHeight)!)
        fieldSizeValueLabel.text = String(fieldSizeStepper.value)
        
        motionBlurSwitch.isOn = gameModel?.motionBlurEnabled ?? false
        hapticFeedbackSwitch.isOn = gameModel?.hapticFeedbackEnabled ?? false
    }
}
