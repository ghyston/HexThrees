import Foundation
import SpriteKit

public func addExpandIcon(scene: SKScene, iconSize: Int) {
	let thirdIconSize = Double(iconSize) / 3.0
	let innerSize = thirdIconSize - 2.0
	
	// right cell
	// outline
	scene.addChild(createHex(
		rad: thirdIconSize,
		pos: CGPoint(x: thirdIconSize / 2.0, y: 0),
		col: SKColor(rgb: 0x333333)))
	
	// inner part
	scene.addChild(createHex(
		rad: innerSize,
		pos: CGPoint(x: thirdIconSize / 2.0, y: 0),
		col: SKColor(rgb: 0xefebeb)))
	
	// shadow
	scene.addChild(createHex(
		rad: thirdIconSize,
		pos: CGPoint(x: -thirdIconSize / 2.0 + 7.0, y: 0),
		col: SKColor(red: 0, green: 0, blue: 0, alpha: 20)))
	
	// left cell
	// outline
	scene.addChild(createHex(
		rad: thirdIconSize,
		pos: CGPoint(x: -thirdIconSize / 2.0, y: 0),
		col: SKColor(rgb: 0x333333)))
	
	// inner part
	scene.addChild(createHex(
		rad: innerSize,
		pos: CGPoint(x: -thirdIconSize / 2.0, y: 0),
		col: SKColor(rgb: 0xdff9a8)))
	
	let arrow = createRightArrowShape(
		length: innerSize / 2.0,
		thickness: 8,
		ratio: 0.3,
		col: SKColor(rgb: 0x444444),
		pos: CGPoint(x: 0.0, y: 0.0))
	
	// arrow
	scene.addChild(arrow)
}
