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
    
    @IBOutlet weak var popupView: UIView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        popupView.layer.cornerRadius = 20
        self.gameModel = ContainerConfig.instance.Resolve() as GameModel
    }
    
    @IBAction func onReset(_ sender: Any) {
        
        //@todo
    }
    
    @IBAction func onClose(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
}
