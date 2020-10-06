//
//  TutorialWelcomeStep.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 09.09.20.
//  Copyright © 2020 Ilja Stepanow. All rights reserved.
//

import Foundation

class TutorialStepWelcomeCmd: GameCMD {
	override func run() {
		self.gameModel.swipeStatus.restrictDirections()
		NotificationCenter.default.post(
			name: .createTutorialGrayLayer,
			object: nil)
		
		let welcomeText = "Welcome to \nHexThrees!" //@todo: translate
		let attrString = NSMutableAttributedString(string: welcomeText)
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.alignment = .center
		let allRange = NSRange(location: 0, length: welcomeText.count)
		let titleRange = NSRange(location: 12, length: 9)
		let smallFont = UIFont(name: "Futura", size: 25)
		let bigFont = UIFont(name: "Futura", size: 35)
		
		attrString.addAttributes(
			[NSAttributedString.Key.paragraphStyle: paragraphStyle,
			 NSAttributedString.Key.foregroundColor : UIColor(rgb: 0xECB235),
			 NSAttributedString.Key.font : smallFont!],
			range: allRange)
		
		attrString.addAttributes(
			[NSAttributedString.Key.foregroundColor : UIColor.white,
			 NSAttributedString.Key.font : bigFont!],
			range: titleRange)
		 
		let textDto = GameScene.TextDescriptionDto(
			text: nil,
			attrText: attrString,
			yPos: GameScene.TextDescriptionPos.Top,
			pulsing: true)
		
		NotificationCenter.default.post(
			name: .updateSceneDescription,
			object: textDto)
	}
}
