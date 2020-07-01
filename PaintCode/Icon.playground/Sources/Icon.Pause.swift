import Foundation
import SpriteKit

public func addPauseIcon(scene: SKScene, iconSize: Int) {
	let outline = Double(iconSize)
	let deltaPosRatio = 0.25
	
	// outline
	scene.addChild(createHex(
		rad: outline,
		pos: CGPoint(x: 0, y: 0),
		col: SKColor(rgb: 0x333333)))
	
	// inner part
	scene.addChild(createHex(
		rad: outline - 4.0,
		pos: CGPoint(x: 0, y: 0),
		col: SKColor(rgb: 0x8DD3D8)))
	
	let leftshape = createRect(outline)
	leftshape.position.x = CGFloat(-outline * deltaPosRatio)
	scene.addChild(leftshape)
	
	let rightshape = createRect(outline)
	rightshape.position.x = CGFloat(outline * deltaPosRatio)
	scene.addChild(rightshape)
}

private func createRect(_ outline: Double) -> SKShapeNode {
	let rectSize = CGSize(
		width: outline * 0.2,
		height: outline * 0.9)
	
	let rectshape = SKShapeNode(
		rectOf: rectSize,
		cornerRadius: CGFloat(outline * 0.1))
	
	rectshape.fillColor = SKColor(rgb: 0x333333)
	rectshape.lineWidth = 0
	
	return rectshape
}
