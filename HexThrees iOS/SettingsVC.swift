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
    
    @IBOutlet weak var fieldSizeValueLabel: UILabel!
    @IBOutlet weak var settingsPopupView: UIView!
    @IBOutlet weak var fieldSizeStepper: UIStepper!
    @IBOutlet weak var paletteChanger: UISegmentedControl!
    
    @IBAction func onCancel(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSave(_ sender: Any) {
        
        //@todo
    }
    
    @IBAction func onFieldSizeChanged(_ sender: Any) {
        
        fieldSizeValueLabel.text = String(fieldSizeStepper.value)
        
        //@todo: change settings here
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
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.gameModel = ContainerConfig.instance.resolve() as GameModel
        
        settingsPopupView.layer.cornerRadius = 20
        
        fieldSizeStepper.minimumValue = 2
        fieldSizeStepper.maximumValue = 7
        
        fieldSizeStepper.value = Double((gameModel?.fieldHeight)!)
        fieldSizeValueLabel.text = String(fieldSizeStepper.value)
    }
}
