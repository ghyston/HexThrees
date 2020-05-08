//
//  FieldGeometry.swift
//  HexThrees
//
//  Created by Ilja Stepanow on 25.06.18.
//  Copyright © 2018 Ilja Stepanow. All rights reserved.
//

import Foundation
import SpriteKit

class FieldGeometry {
	private let gap: Float = 4.0
	
	public let hexCellPath: CGPath
	public let outlinePath: CGPath
	
	private let hexRad: Float
	private let cellWidth: Float //@todo: computable
	private let cellHeight: Float //@todo: computable
	private let offsetX: Float
	private let offsetY: Float
	
	init(screenSize: CGSize, fieldW: Float, fieldH: Float, offsetX: Float = 0.0, offsetY: Float = 0.0) {
		self.hexRad = FieldGeometry.calculateHexRad(
			viewSize: screenSize,
			fieldHCellsCount: fieldW,
			fieldVCellsCount: fieldH,
			gap: self.gap)
		
		self.offsetX = offsetX
		self.offsetY = offsetY
		
		self.hexCellPath = FieldGeometry.createPath(rad: Double(self.hexRad))
		self.outlinePath = FieldGeometry.createPath(rad: Double(self.hexRad + self.gap))
		
		self.cellWidth = self.hexRad * 1.732
		self.cellHeight = self.hexRad * 2
	}
	
	convenience init(screenSize: CGSize, coords: [AxialCoord]) {
		
		assert(!coords.isEmpty, "could not create field without coordinates!")
		
		let xs = coords.map { $0.x }
		let ys = coords.map { $0.y }
		
		let minX = xs.min()!
		let maxX = xs.max()!
		let minY = ys.min()!
		let maxY = ys.max()!
		
		self.init(
			screenSize: screenSize,
			fieldW: Float(maxX - minX) / 2.0 + 1.0,
			fieldH: Float(maxY - minY) / 2.0 + 1.0,
			offsetX: Float(minX + maxX) / 2.0,
			offsetY: Float(minY + maxY) / 2.0) // minY + fieldH - 1 simplified
	}
	
	//@todo: Comparable?
	func compare(to geometry: FieldGeometry) -> Bool {
		geometry.hexRad == hexRad &&
		geometry.offsetX == offsetX &&
		geometry.offsetY == offsetY
	}
	
	func hexScale(to geometry: FieldGeometry) -> Float {
		geometry.hexRad / hexRad
	}
	
	func createHexCellShape() -> SKShapeNode {
		self.createShape(path: self.hexCellPath)
	}
	
	//@todo: is it still used?
	func createOutlineShape() -> SKShapeNode {
		self.createShape(path: self.outlinePath)
	}
	
	private func createShape(path: CGPath) -> SKShapeNode {
		let hexShape = SKShapeNode()
		hexShape.path = path
		return hexShape
	}
	
	class func calculateHexRad(viewSize: CGSize, fieldHCellsCount: Float, fieldVCellsCount: Float, gap: Float) -> Float {
		let fieldW = Float(viewSize.width * 0.9) // Here convertion is cgfloat -> float. Otherwise compiler went crazy in next lines
		let fieldH = Float(viewSize.height * 0.8)
		
		let minRadByWidth = ((fieldW + gap) / fieldHCellsCount - gap) / 1.732
		let minRadByHeight = ((fieldH + gap) / fieldVCellsCount - gap) / (2.0 * 1.732)
		
		return min(minRadByWidth, minRadByHeight)
	}
	
	class func createGearPath(radIn: Double, radOut: Double, count: Int) -> CGPath {
		assert(radOut > radIn, "wrong radius")
		assert(radOut > 0, "wrong out radius")
		assert(radIn > 0, "wrong in radius")
		assert(count >= 3, "wrong gear count")
		
		let gearPath = CGMutablePath()
		let start = CGPoint(x: 0, y: radOut)
		gearPath.move(to: start)
		
		let Δα = 6.28 / Double(count)
		
		for i in 0 ..< count {
			let leftα = Δα * (Double(i) + 0.25)
			let rightα = Δα * (Double(i) + 0.75)
			
			let p0 = CGPoint(x: radOut * cos(leftα), y: radOut * sin(leftα))
			let p1 = CGPoint(x: radIn * cos(leftα), y: radIn * sin(leftα))
			let p2 = CGPoint(x: radIn * cos(rightα), y: radIn * sin(rightα))
			let p3 = CGPoint(x: radOut * cos(rightα), y: radOut * sin(rightα))
			
			gearPath.addLine(to: p0)
			gearPath.addLine(to: p1)
			gearPath.addLine(to: p2)
			gearPath.addLine(to: p3)
		}
		gearPath.addLine(to: start)
		return gearPath
	}
	
	class func createPath(rad: Double) -> CGPath {
		let hexPath = CGMutablePath()
		
		let xCoef = 1.732 * 0.5
		let yCoef = 0.5
		let curveCoef = 0.85
		
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
	
	class func createPathWOCurving(rad: Double) -> CGPath {
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
	
	func ToScreenCoord(_ a: AxialCoord) -> CGPoint {
		let w = Float(self.cellWidth + self.gap)
		let h = Float(self.cellHeight + self.gap * 1.732 * 2.0)
		
		let x = (Float(a.c - a.r) - offsetX) * 0.5 * w
		let y = (Float(a.c + a.r) - offsetY) * (w * 0.5 + h / (2.0 * 1.732))
		
		return CGPoint(
			x: CGFloat(x),
			y: CGFloat(y))
	}
	
	func ToScreenCoord(_ a: CubeCoord) -> CGPoint {
		return self.ToScreenCoord(AxialCoord(a))
	}
}
