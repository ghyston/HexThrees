import Foundation
import SpriteKit

public func addAppIcon(scene: SKScene, iconSize: Int) {
	let rect = SKShapeNode(rect: CGRect(
		x: -iconSize / 2, y: -iconSize / 2,
		width: iconSize, height: iconSize), cornerRadius: 40)
	rect.fillColor = SKColor(rgb: 0x202020)
	scene.addChild(rect)
	
	// outline
	scene.addChild(createHex(
		rad: 117,
		pos: CGPoint(x: 57, y: 50),
		col: .white))
	
	scene.addChild(createHex(
		rad: 87,
		pos: CGPoint(x: -83, y: 40),
		col: .white))
	
	scene.addChild(createHex(
		rad: 97,
		pos: CGPoint(x: -3, y: -70),
		col: .white))
	// actual hexes:
	
	scene.addChild(createHex(
		rad: 115,
		pos: CGPoint(x: 57, y: 50),
		col: SKColor(rgb: 0x647F5A)))
	
	// shadow of red
	scene.addChild(createHex(
		rad: 90,
		pos: CGPoint(x: -78, y: 42),
		col: SKColor(red: 0, green: 0, blue: 0, alpha: 20)))
	
	scene.addChild(createHex(
		rad: 85,
		pos: CGPoint(x: -83, y: 40),
		col: SKColor(rgb: 0xDE6C4C)))
	
	// shadow of yellow
	scene.addChild(createHex(
		rad: 100,
		pos: CGPoint(x: -3, y: -65),
		col: SKColor(red: 0, green: 0, blue: 0, alpha: 20)))
	
	scene.addChild(createHex(
		rad: 95,
		pos: CGPoint(x: -3, y: -70),
		col: SKColor(rgb: 0xDFB138)))
}
