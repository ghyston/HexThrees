//
//  TutorialSwipteRulesVC.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 31.03.19.
//  Copyright © 2019 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

protocol HelpScene: SKScene {
	init(frameSize: CGSize)
    func ruleName() -> String
}

class HelpRulesVC<SceneClass: HelpScene>: UIViewController {
    
	override func viewDidLoad() {
		super.viewDidLoad()

		let skView = self.view as! SKView

		let scene = SceneClass(frameSize: skView.frame.size)

        if let label = getLabel() {
            label.text = scene.ruleName()
            label.adjustsFontSizeToFitWidth = true
        }
        
		skView.presentScene(scene)
		skView.ignoresSiblingOrder = true
		skView.showsFPS = false
		skView.showsNodeCount = false
	}
    
    func getLabel() -> UILabel? { nil }
}

class HelpSwipeRulesVC: HelpRulesVC<HelpSwipeScene> {
    @IBOutlet weak var ruleName: UILabel!
    
    override func getLabel() -> UILabel? { ruleName }
}

class HelpMergeRulesVC: HelpRulesVC<HelpMergingScene> {
    @IBOutlet weak var ruleName: UILabel!
    
    override func getLabel() -> UILabel? { ruleName }
}
