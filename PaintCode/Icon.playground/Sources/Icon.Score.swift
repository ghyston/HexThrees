import Foundation
import SpriteKit

public func addDoubleScoreIcon(scene: SKScene, iconSize: Int) {
	let outerSize = Double(iconSize)
	let innerSize = outerSize * 0.7
	let fontSize = CGFloat(outerSize * 0.3)
	
	// outline
	scene.addChild(createHex(
		rad: outerSize,
		pos: CGPoint(x: 0, y: 0),
		col: SKColor(rgb: 0x333333)))
	
	// inner
	scene.addChild(createHex(
		rad: innerSize,
		pos: CGPoint(x: 0, y: 0),
		col: SKColor(rgb: 0xdff9a8)))
	
	let label = SKLabelNode(text: "x2")
	label.fontSize = fontSize
	label.fontName = "Futura"
	label.fontColor = .black
	label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
	scene.addChild(label)
}

public func addTripleScoreIcon(scene: SKScene, iconSize: Int) {
	let outerSize = Double(iconSize)
	let circle1Size = outerSize * 0.75
	let circle2Size = outerSize * 0.5
	let fontSize = CGFloat(outerSize * 0.3)
	
	// outline
	scene.addChild(createHex(
		rad: outerSize,
		pos: CGPoint(x: 0, y: 0),
		col: SKColor(rgb: 0x333333)))
	
	// circle1
	scene.addChild(createHex(
		rad: outerSize - 2.0,
		pos: CGPoint(x: 0, y: 0),
		col: SKColor(rgb: 0xdff9a8)))
	
	// circle2
	scene.addChild(createHex(
		rad: circle1Size,
		pos: CGPoint(x: 0, y: 0),
		col: SKColor(rgb: 0x333333)))
	
	// circle2
	scene.addChild(createHex(
		rad: circle2Size,
		pos: CGPoint(x: 0, y: 0),
		col: SKColor(rgb: 0xdff9a8)))
	
	let label = SKLabelNode(text: "x3")
	label.fontSize = fontSize
	label.fontName = "Futura"
	label.fontColor = .black
	label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
	scene.addChild(label)
}
