//
//  EndGameVC.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 16.10.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class GameOverVC : UIViewController {
    
    var gameModel : GameModel?
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var ScoreLabel: UILabel!
    
    @IBAction func onResetGame(_ sender: Any) {
        
        NotificationCenter.default.post(name: .resetGame, object: nil)
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        popupView.layer.cornerRadius = 20
        
        self.gameModel = ContainerConfig.instance.resolve() as GameModel
        ScoreLabel.text = "\(self.gameModel!.score)"
        
    }
}
