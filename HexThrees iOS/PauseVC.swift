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
    
    @IBOutlet weak var popupView: UIView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        popupView.layer.cornerRadius = 20
    }
    
    @IBAction func onReset(_ sender: Any) {
        
        NotificationCenter.default.post(name: .resetGame, object: nil)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClose(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
}
