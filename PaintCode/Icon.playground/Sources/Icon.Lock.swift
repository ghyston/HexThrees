import Foundation
import SpriteKit

public func addLockIcon(scene: SKScene, iconSize: Int) {
	let bottomSize = CGFloat(iconSize) * 0.6
	let upperSize = CGFloat(iconSize) * 0.4
	
	// bottom part
	let bottomPath = createLockBottomPath(size: bottomSize)
	let bottom = SKShapeNode(path: bottomPath)
	bottom.lineWidth = 5.0
	bottom.fillColor = SKColor(rgb: 0x406C8B)
	bottom.strokeColor = SKColor(rgb: 0x333333)
	
	let upperPath = createLockUpperPath(size: upperSize)
	let holder = SKShapeNode()
	holder.path = upperPath
	holder.lineWidth = 7.0
	holder.lineCap = .round
	holder.strokeColor = SKColor(rgb: 0x333333)
	holder.position.y = upperSize * 0.7
	
	let holePath = createLockHolePath(size: upperSize)
	let hole = SKShapeNode()
	hole.path = holePath
	hole.lineWidth = 0.0
	hole.fillColor = SKColor(rgb: 0x333333)
	//hole.position.y = upperSize
	
	scene.addChild(holder)
	scene.addChild(bottom)
	scene.addChild(hole)
}
