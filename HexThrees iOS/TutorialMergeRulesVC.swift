//
//  TutorialVC.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 24.03.19.
//  Copyright © 2019 Ilja Stepanow. All rights reserved.
//

import UIKit
import SpriteKit

class TutorialMergeRulesVC : UIViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let skView = self.view as! SKView
        
        let scene = TutorialMergingScene.create(frameSize: skView.frame.size)
        
        skView.presentScene(scene)
        
        skView.ignoresSiblingOrder = true
        skView.showsFPS = true
        skView.showsNodeCount = false
    }
}
