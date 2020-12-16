//
//  AskForReviewCmd.swift
//  HexThrees iOS
//
//  Created by Ilja Stepanow on 16.12.20.
//  Copyright © 2020 Ilja Stepanow. All rights reserved.
//

import Foundation

class AskForReviewCmd: GameCMD {
    
    let reason: ResetGameReason
    
    init(_ gameModel: GameModel, resetReason: ResetGameReason) {
        reason = resetReason
        super.init(gameModel)
    }
    
    override func run() {
        if  (reason == ResetGameReason.GameOverRecord &&
            gameModel.score > GameConstants.GameScoreRecordToAskForReview) ||
            (reason == ResetGameReason.GameOver &&
            gameModel.score > GameConstants.GameScoreToAskForReview) {
            IAPHelper.shared.requestReview()
        }
    }
}
