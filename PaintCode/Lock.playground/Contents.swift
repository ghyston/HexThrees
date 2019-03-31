//: A SpriteKit based Playground

import PlaygroundSupport
import SpriteKit

extension SKColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(red: Int, green: Int, blue: Int, alpha: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(alpha) / 255.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}


class GameScene: SKScene {
    
    private var label : SKLabelNode!
    private var spinnyNode : SKShapeNode!
    
    func createPath(rad: Double) -> CGPath {
        
        let hexPath = CGMutablePath.init()
        
        let xCoef = 1.732 * 0.5
        let yCoef = 0.5
        let curveCoef = 0.85
        
        let p0 = CGPoint.init(x: 0.0, y: rad)
        let p1 = CGPoint.init(x: rad * xCoef, y: rad * yCoef)
        let p2 = CGPoint.init(x: rad * xCoef, y: -rad * yCoef)
        let p3 = CGPoint.init(x: 0.0, y: -rad)
        let p4 = CGPoint.init(x: -rad * xCoef, y: -rad * yCoef)
        let p5 = CGPoint.init(x: -rad * xCoef, y: rad * yCoef)
        
        let p0dy = CGFloat( (rad - rad * yCoef) * (1 - curveCoef))
        let p1dy = CGFloat( rad * yCoef * (1 - curveCoef))
        let dx = CGFloat( rad * xCoef * (1 - curveCoef))
        
        
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
    
    func createPathWOCurving(rad: Double) -> CGPath {
        
        let hexPath = CGMutablePath.init()
        
        let xCoef = 1.732 * 0.5
        let yCoef = 0.5
        
        let p0 = CGPoint.init(x: 0.0, y: rad)
        let p1 = CGPoint.init(x: rad * xCoef, y: rad * yCoef)
        let p2 = CGPoint.init(x: rad * xCoef, y: -rad * yCoef)
        let p3 = CGPoint.init(x: 0.0, y: -rad)
        let p4 = CGPoint.init(x: -rad * xCoef, y: -rad * yCoef)
        let p5 = CGPoint.init(x: -rad * xCoef, y: rad * yCoef)
        
        hexPath.move(to: p0)
        hexPath.addLine(to: p1)
        hexPath.addLine(to: p2)
        hexPath.addLine(to: p3)
        hexPath.addLine(to: p4)
        hexPath.addLine(to: p5)
        hexPath.addLine(to: p0)
        
        return hexPath
    }
    
    private func createHex(rad: Double, pos: CGPoint, col: SKColor) -> SKShapeNode {
        
        let curvedPath0 = createPath(rad: rad)
        let hexCurvedShape0 = SKShapeNode.init(path: curvedPath0)
        hexCurvedShape0.fillColor = col
        hexCurvedShape0.strokeColor = .white //SKColor (rgb: 0x83789F)
        hexCurvedShape0.position = pos
        hexCurvedShape0.lineWidth = 0
        
        return hexCurvedShape0
    }
    
    override func didMove(to view: SKView) {
    
        backgroundColor = .white
        
        let iconSize = 360
        
        let rect = SKShapeNode(rect: CGRect(
            x: -iconSize/2, y: -iconSize/2,
            width: iconSize, height: iconSize), cornerRadius: 40)
        rect.fillColor = SKColor (rgb: 0x202020)
        addChild(rect)
        
        //outline
        addChild(createHex(
            rad: 117,
            pos: CGPoint(x: 57, y: 50),
            col: .white))
        
        addChild(createHex(
            rad: 87,
            pos: CGPoint(x: -83, y: 40),
            col: .white))
        
        addChild(createHex(
            rad: 97,
            pos: CGPoint(x: -3, y: -70),
            col: .white))
        //actual hexes:
        
        addChild(createHex(
            rad: 115,
            pos: CGPoint(x: 57, y: 50),
            col: SKColor (rgb: 0x647F5A)))
        
        // shadow of red
        addChild(createHex(
            rad: 90,
            pos: CGPoint(x: -78, y: 42),
            col: SKColor (red: 0, green: 0, blue: 0, alpha: 20)))
        
        addChild(createHex(
            rad: 85,
            pos: CGPoint(x: -83, y: 40),
            col: SKColor (rgb: 0xDE6C4C)))
        
        //shadow of yellow
        addChild(createHex(
            rad: 100,
            pos: CGPoint(x: -3, y: -65),
            col: SKColor (red: 0, green: 0, blue: 0, alpha: 20)))
        
        addChild(createHex(
            rad: 95,
            pos: CGPoint(x: -3, y: -70),
            col: SKColor (rgb: 0xDFB138)))
    }
    
    @objc static override var supportsSecureCoding: Bool {
        // SKNode conforms to NSSecureCoding, so any subclass going
        // through the decoding process must support secure coding
        get {
            return true
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

// Load the SKScene from 'GameScene.sks'
let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 640, height: 480))
if let scene = GameScene(fileNamed: "GameScene") {
    // Set the scale mode to scale to fit the window
    scene.scaleMode = .aspectFill
    
    // Present the scene
    sceneView.presentScene(scene)
}

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
