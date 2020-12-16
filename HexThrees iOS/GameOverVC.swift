//
//  EndGameVC.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 16.10.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class GameOverVC: UIViewController {
	
	@IBOutlet var popupView: UIView!
	@IBOutlet var ScoreLabel: UILabel!
	@IBOutlet var scoreDescription: UILabel!
    
    private var isRecord = false
	
	@IBAction func onResetGame(_ sender: Any) {
        let reason = self.isRecord
            ? ResetGameReason.GameOverRecord
            : ResetGameReason.GameOver
        
        NotificationCenter.default.post(name: .resetGame, object: reason)
		dismiss(animated: true, completion: nil)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		popupView.layer.cornerRadius = 20
		
		let gameModel = ContainerConfig.instance.resolve() as GameModel
		let prevRecord = UserDefaults.standard.integer(forKey: SettingsKey.BestScore.rawValue)
		let currentScore = gameModel.score
        self.isRecord = prevRecord < currentScore
        
		if self.isRecord {
			UserDefaults.standard.set(currentScore, forKey: SettingsKey.BestScore.rawValue)
            scoreDescription.text = "gameOver.newRecord".localized()
		}
		else {
            scoreDescription.text = "gameOver.yourScore".localized()
		}
		
		ScoreLabel.text = "\(currentScore)"
	}
}
