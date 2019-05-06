//
//  TutorialSwipteRulesVC.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 31.03.19.
//  Copyright © 2019 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

protocol TutorialScene : SKScene {
    init(frameSize : CGSize)
}

class TutorialRulesVC<SceneClass : TutorialScene> : UIViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let skView = self.view as! SKView
        
        let scene = SceneClass(frameSize: skView.frame.size)
        
        skView.presentScene(scene)
        skView.ignoresSiblingOrder = true
        skView.showsFPS = false
        skView.showsNodeCount = false
    }
}

class TutorialSwipeRulesVC : TutorialRulesVC<TutorialSwipeScene> {
}

class TutorialMergeRulesVC : TutorialRulesVC<TutorialMergingScene> {
}
