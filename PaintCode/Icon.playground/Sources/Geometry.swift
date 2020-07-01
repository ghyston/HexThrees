
import Foundation
import SpriteKit

private func createPath(rad: Double) -> CGPath {
	let hexPath = CGMutablePath()
	
	let xCoef = 1.732 * 0.5
	let yCoef = 0.5
	let curveCoef = 0.8
	
	let p0 = CGPoint(x: 0.0, y: rad)
	let p1 = CGPoint(x: rad * xCoef, y: rad * yCoef)
	let p2 = CGPoint(x: rad * xCoef, y: -rad * yCoef)
	let p3 = CGPoint(x: 0.0, y: -rad)
	let p4 = CGPoint(x: -rad * xCoef, y: -rad * yCoef)
	let p5 = CGPoint(x: -rad * xCoef, y: rad * yCoef)
	
	let p0dy = CGFloat((rad - rad * yCoef) * (1 - curveCoef))
	let p1dy = CGFloat(rad * yCoef * (1 - curveCoef))
	let dx = CGFloat(rad * xCoef * (1 - curveCoef))
	
	let p0l = CGPoint(x: p0.x - dx, y: p0.y - p0dy)
	let p0r = CGPoint(x: p0.x + dx, y: p0.y - p0dy)
	
	let p1l = CGPoint(x: p1.x - dx, y: p1.y + p1dy)
	let p1r = CGPoint(x: p1.x, y: p1.y - p1dy)
	
	let p2l = CGPoint(x: p2.x, y: p2.y + p1dy)
	let p2r = CGPoint(x: p2.x - dx, y: p2.y - p1dy)
	
	let p3l = CGPoint(x: p3.x + dx, y: p3.y + p0dy)
	let p3r = CGPoint(x: p3.x - dx, y: p3.y + p0dy)
	
	let p4l = CGPoint(x: p4.x + dx, y: p4.y - p1dy)
	let p4r = CGPoint(x: p4.x, y: p4.y + p0dy)
	
	let p5l = CGPoint(x: p5.x, y: p5.y - p1dy)
	let p5r = CGPoint(x: p5.x + dx, y: p5.y + p0dy)
	
	hexPath.move(to: p0l)
	hexPath.addQuadCurve(to: p0r, control: p0)
	hexPath.addLine(to: p1l)
	hexPath.addQuadCurve(to: p1r, control: p1)
	hexPath.addLine(to: p2l)
	hexPath.addQuadCurve(to: p2r, control: p2)
	hexPath.addLine(to: p3l)
	
	hexPath.addQuadCurve(to: p3r, control: p3)
	hexPath.addLine(to: p4l)
	
	hexPath.addQuadCurve(to: p4r, control: p4)
	hexPath.addLine(to: p5l)
	
	hexPath.addQuadCurve(to: p5r, control: p5)
	hexPath.addLine(to: p0l)
	
	return hexPath
}

private func createPathWOCurving(rad: Double) -> CGPath {
	let hexPath = CGMutablePath()
	
	let xCoef = 1.732 * 0.5
	let yCoef = 0.5
	
	let p0 = CGPoint(x: 0.0, y: rad)
	let p1 = CGPoint(x: rad * xCoef, y: rad * yCoef)
	let p2 = CGPoint(x: rad * xCoef, y: -rad * yCoef)
	let p3 = CGPoint(x: 0.0, y: -rad)
	let p4 = CGPoint(x: -rad * xCoef, y: -rad * yCoef)
	let p5 = CGPoint(x: -rad * xCoef, y: rad * yCoef)
	
	hexPath.move(to: p0)
	hexPath.addLine(to: p1)
	hexPath.addLine(to: p2)
	hexPath.addLine(to: p3)
	hexPath.addLine(to: p4)
	hexPath.addLine(to: p5)
	hexPath.addLine(to: p0)
	
	return hexPath
}

public func createHex(rad: Double, pos: CGPoint, col: SKColor) -> SKShapeNode {
	let curvedPath0 = createPath(rad: rad)
	let hexCurvedShape0 = SKShapeNode(path: curvedPath0)
	hexCurvedShape0.fillColor = col
	hexCurvedShape0.strokeColor = .white // SKColor (rgb: 0x83789F)
	hexCurvedShape0.position = pos
	hexCurvedShape0.lineWidth = 0
	
	return hexCurvedShape0
}

private func createRightArrowPath(_ length: Double, _ thickness: Double, _ ratio: Double) -> CGPath {
	let arrowPath = CGMutablePath()
	let arrowHeadRatio = 1.5
	
	let p0 = CGPoint(x: -length * 0.5, y: -thickness * 0.5)
	let p1 = CGPoint(x: -length * 0.5, y: thickness * 0.5)
	
	let p2 = CGPoint(x: length * (0.5 - ratio), y: thickness * 0.5)
	let p3 = CGPoint(x: length * (0.5 - ratio), y: thickness * arrowHeadRatio)
	
	let p4 = CGPoint(x: length * 0.5, y: 0)
	
	let p5 = CGPoint(x: length * (0.5 - ratio), y: -thickness * arrowHeadRatio)
	let p6 = CGPoint(x: length * (0.5 - ratio), y: -thickness * 0.5)
	
	arrowPath.move(to: p0)
	arrowPath.addLine(to: p1)
	arrowPath.addLine(to: p2)
	arrowPath.addLine(to: p3)
	arrowPath.addLine(to: p4)
	arrowPath.addLine(to: p5)
	arrowPath.addLine(to: p6)
	arrowPath.addLine(to: p0)
	
	return arrowPath
}

public func createRightArrowShape(length: Double, thickness: Double, ratio: Double, col: SKColor, pos: CGPoint) -> SKShapeNode {
	let path = createRightArrowPath(length, thickness, ratio)
	let shape = SKShapeNode(path: path)
	shape.fillColor = col
	shape.position = pos
	shape.lineWidth = 0
	
	return shape
}

public func createLockBottomPath(size: CGFloat) -> CGPath {
	let path = CGMutablePath()
	
	let p0 = CGPoint(x: -size * 0.5, y: size * 0.3)
	
	let pCenter = CGPoint(x: 0, y: 0)
	// let p3 = CGPoint(x: size * 0.5, y: 0)
	let p2 = CGPoint(x: size * 0.5, y: size * 0.3)
	
	path.move(to: p0)
	// path.addLine(to: p1)
	
	// path.addQuadCurve(to: p3, control: p2)
	
	path.addArc(
		center: pCenter,
		radius: size * 0.5,
		startAngle: .pi,
		endAngle: 0,
		clockwise: false)
	
	path.addLine(to: p2)
	path.addLine(to: p0)
	
	return path
}

public func createLockUpperPath(size: CGFloat) -> CGPath {
	let path = CGMutablePath()
	
	let p0 = CGPoint(x: -size * 0.5, y: -size * 0.3)
	let p1 = CGPoint(x: -size * 0.5, y: 0)
	
	let pCenter = CGPoint(x: 0, y: 0)
	
	let p2 = CGPoint(x: size * 0.5, y: -size * 0.3)
	
	path.move(to: p0)
	path.addLine(to: p1)
	path.addArc(
		center: pCenter,
		radius: size * 0.5,
		startAngle: .pi,
		endAngle: 0,
		clockwise: true)
	path.addLine(to: p2)
	
	return path
}

public func createLockHolePath(size: CGFloat) -> CGPath {
	let path = CGMutablePath()
	
	let rad1 = size * 0.1
	let rad2 = size * 0.05
	let h = size * 0.5
	
	let p0 = CGPoint(x: -rad2 * 0.5, y: 0)
	let upC = CGPoint(x: 0, y: 0)
	let p1 = CGPoint(x: -rad2, y: -h)
	let downC = CGPoint(x: 0, y: -h)
	let p2 = CGPoint(x: rad2 * 0.5, y: 0)
	
	path.move(to: p0)
	path.addLine(to: p1)
	
	path.addArc(
		center: downC,
		radius: rad2,
		startAngle: .pi,
		endAngle: 0,
		clockwise: false)
	
	path.addLine(to: p2)
	
	path.addArc(
		center: upC,
		radius: rad1,
		startAngle: 0,
		endAngle: .pi * 2.0,
		clockwise: false)
	
	return path
}
