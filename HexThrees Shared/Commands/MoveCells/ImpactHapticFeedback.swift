import Foundation
import SpriteKit

class ImpactHapticFeedbackCMD : GameCMD {
    
    override func run(){
        gameModel.hapticManager.impact()
    }
}
