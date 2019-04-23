//
//  TutorialSwipteRulesVC.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 31.03.19.
//  Copyright © 2019 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit


//@todo: use template and merge with TutorialMergeRulesVC
class TutorialSwipeRulesVC : UIViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let skView = self.view as! SKView
        
        let scene = TutorialSwipeScene(frameSize: skView.frame.size)
        
        skView.presentScene(scene)
        skView.ignoresSiblingOrder = true
        skView.showsFPS = true
        skView.showsNodeCount = false
    }
}
