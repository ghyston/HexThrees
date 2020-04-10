//
//  EndGameVC.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 16.10.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation

class GameOverVC: UIViewController {
	var gameModel: GameModel?
	
	@IBOutlet var popupView: UIView!
	@IBOutlet var ScoreLabel: UILabel!
	
	@IBAction func onResetGame(_ sender: Any) {
		NotificationCenter.default.post(name: .resetGame, object: nil)
		dismiss(animated: true, completion: nil)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		popupView.layer.cornerRadius = 20
		
		gameModel = ContainerConfig.instance.resolve() as GameModel
		ScoreLabel.text = "\(gameModel!.score)"
	}
}
