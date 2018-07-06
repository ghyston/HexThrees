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
    
    @IBOutlet weak var settingsPopupView: UIView!
    @IBOutlet weak var fieldSizeLabel: UILabel!
    @IBOutlet weak var fieldSizeStepper: UIStepper!
    
    @IBAction func onCancel(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSave(_ sender: Any) {
        
        //@todo
    }
    
    @IBAction func onFieldSizeChanged(_ sender: Any) {
        
         fieldSizeLabel.text = String(fieldSizeStepper.value)
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.gameModel = ContainerConfig.instance.Resolve() as GameModel
        
        settingsPopupView.layer.cornerRadius = 20
        
        fieldSizeStepper.minimumValue = 2
        fieldSizeStepper.maximumValue = 7
        
        fieldSizeStepper.value = Double((gameModel?.fieldHeight)!)
        
    }
}
